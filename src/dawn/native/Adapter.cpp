// Copyright 2023 The Dawn & Tint Authors
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "dawn/native/Adapter.h"

#include <algorithm>
#include <memory>
#include <string>
#include <tuple>
#include <unordered_set>
#include <utility>
#include <vector>

#include "dawn/common/Log.h"
#include "dawn/native/ChainUtils.h"
#include "dawn/native/Device.h"
#include "dawn/native/Instance.h"
#include "dawn/native/PhysicalDevice.h"
#include "partition_alloc/pointers/raw_ptr.h"

namespace dawn::native {
namespace {
static constexpr DeviceDescriptor kDefaultDeviceDesc = {};
}  // anonymous namespace

AdapterBase::AdapterBase(InstanceBase* instance,
                         Ref<PhysicalDeviceBase> physicalDevice,
                         FeatureLevel featureLevel,
                         const TogglesState& requiredAdapterToggles,
                         wgpu::PowerPreference powerPreference)
    : mInstance(instance),
      mPhysicalDevice(std::move(physicalDevice)),
      mFeatureLevel(featureLevel),
      mTogglesState(requiredAdapterToggles),
      mPowerPreference(powerPreference) {
    DAWN_ASSERT(mPhysicalDevice->SupportsFeatureLevel(featureLevel));
    DAWN_ASSERT(mTogglesState.GetStage() == ToggleStage::Adapter);
    // Cache the supported features of this adapter. Note that with device toggles overriding, a
    // device created by this adapter may support features not in this set and vice versa.
    mSupportedFeatures = mPhysicalDevice->GetSupportedFeatures(mTogglesState);
}

AdapterBase::~AdapterBase() = default;

void AdapterBase::SetUseTieredLimits(bool useTieredLimits) {
    mUseTieredLimits = useTieredLimits;
}

FeaturesSet AdapterBase::GetSupportedFeatures() const {
    return mSupportedFeatures;
}

PhysicalDeviceBase* AdapterBase::GetPhysicalDevice() {
    return mPhysicalDevice.Get();
}

const PhysicalDeviceBase* AdapterBase::GetPhysicalDevice() const {
    return mPhysicalDevice.Get();
}

InstanceBase* AdapterBase::GetInstance() const {
    return mInstance.Get();
}

InstanceBase* AdapterBase::APIGetInstance() const {
    InstanceBase* instance = mInstance.Get();
    DAWN_ASSERT(instance != nullptr);
    instance->APIAddRef();
    return instance;
}

wgpu::Status AdapterBase::APIGetLimits(SupportedLimits* limits) const {
    DAWN_ASSERT(limits != nullptr);
    UnpackedPtr<SupportedLimits> unpacked;
    if (mInstance->ConsumedError(ValidateAndUnpack(limits), &unpacked)) {
        return wgpu::Status::Error;
    }

    if (mUseTieredLimits) {
        limits->limits = ApplyLimitTiers(mPhysicalDevice->GetLimits().v1);
    } else {
        limits->limits = mPhysicalDevice->GetLimits().v1;
    }

    // TODO(349125474): Deprecate DawnExperimentalSubgroupLimits.
    if (auto* subgroupLimits = unpacked.Get<DawnExperimentalSubgroupLimits>()) {
        if (!mTogglesState.IsEnabled(Toggle::AllowUnsafeAPIs)) {
            // If AllowUnsafeAPIs is not enabled, return the default-initialized
            // DawnExperimentalSubgroupLimits object, where minSubgroupSize and
            // maxSubgroupSize are WGPU_LIMIT_U32_UNDEFINED.
            *subgroupLimits = DawnExperimentalSubgroupLimits{};
        } else {
            *subgroupLimits = mPhysicalDevice->GetLimits().experimentalSubgroupLimits;
        }
    }

    return wgpu::Status::Success;
}

wgpu::Status AdapterBase::APIGetInfo(AdapterInfo* info) const {
    DAWN_ASSERT(info != nullptr);

    AdapterProperties properties = {};
    properties.nextInChain = info->nextInChain;
    if (GetPropertiesInternal(&properties) == wgpu::Status::Error) {
        return wgpu::Status::Error;
    }

    // Get lengths, with null terminators.
    size_t vendorCLen = mPhysicalDevice->GetVendorName().length() + 1;
    size_t architectureCLen = mPhysicalDevice->GetArchitectureName().length() + 1;
    size_t deviceCLen = mPhysicalDevice->GetName().length() + 1;
    size_t descriptionCLen = mPhysicalDevice->GetDriverDescription().length() + 1;

    // Allocate space for all strings.
    char* ptr = new char[vendorCLen + architectureCLen + deviceCLen + descriptionCLen];

    info->vendor = ptr;
    memcpy(ptr, mPhysicalDevice->GetVendorName().c_str(), vendorCLen);
    ptr += vendorCLen;

    info->architecture = ptr;
    memcpy(ptr, mPhysicalDevice->GetArchitectureName().c_str(), architectureCLen);
    ptr += architectureCLen;

    info->device = ptr;
    memcpy(ptr, mPhysicalDevice->GetName().c_str(), deviceCLen);
    ptr += deviceCLen;

    info->description = ptr;
    memcpy(ptr, mPhysicalDevice->GetDriverDescription().c_str(), descriptionCLen);
    ptr += descriptionCLen;

    info->backendType = mPhysicalDevice->GetBackendType();
    info->adapterType = mPhysicalDevice->GetAdapterType();
    info->vendorID = mPhysicalDevice->GetVendorId();
    info->deviceID = mPhysicalDevice->GetDeviceId();
    info->compatibilityMode = mFeatureLevel == FeatureLevel::Compatibility;

    return wgpu::Status::Success;
}

wgpu::Status AdapterBase::APIGetProperties(AdapterProperties* properties) const {
    mInstance->EmitDeprecationWarning("GetProperties is deprecated, use GetInfo instead.");
    return GetPropertiesInternal(properties);
}

wgpu::Status AdapterBase::GetPropertiesInternal(AdapterProperties* properties) const {
    DAWN_ASSERT(properties != nullptr);
    UnpackedPtr<AdapterProperties> unpacked;
    if (mInstance->ConsumedError(ValidateAndUnpack(properties), &unpacked)) {
        return wgpu::Status::Error;
    }

    bool hadError = false;
    if (unpacked.Get<AdapterPropertiesMemoryHeaps>() != nullptr &&
        !mSupportedFeatures.IsEnabled(wgpu::FeatureName::AdapterPropertiesMemoryHeaps)) {
        hadError |= mInstance->ConsumedError(
            DAWN_VALIDATION_ERROR("Feature AdapterPropertiesMemoryHeaps is not available."));
    }
    if (unpacked.Get<AdapterPropertiesD3D>() != nullptr &&
        !mSupportedFeatures.IsEnabled(wgpu::FeatureName::AdapterPropertiesD3D)) {
        hadError |= mInstance->ConsumedError(
            DAWN_VALIDATION_ERROR("Feature AdapterPropertiesD3D is not available."));
    }
    if (unpacked.Get<AdapterPropertiesVk>() != nullptr &&
        !mSupportedFeatures.IsEnabled(wgpu::FeatureName::AdapterPropertiesVk)) {
        hadError |= mInstance->ConsumedError(
            DAWN_VALIDATION_ERROR("Feature AdapterPropertiesVk is not available."));
    }
    if (hadError) {
        return wgpu::Status::Error;
    }

    if (auto* powerPreferenceDesc = unpacked.Get<DawnAdapterPropertiesPowerPreference>()) {
        powerPreferenceDesc->powerPreference = mPowerPreference;
    }

    mPhysicalDevice->PopulateBackendProperties(unpacked);

    properties->vendorID = mPhysicalDevice->GetVendorId();
    properties->deviceID = mPhysicalDevice->GetDeviceId();
    properties->adapterType = mPhysicalDevice->GetAdapterType();
    properties->backendType = mPhysicalDevice->GetBackendType();
    properties->compatibilityMode = mFeatureLevel == FeatureLevel::Compatibility;

    // Get lengths, with null terminators.
    size_t vendorNameCLen = mPhysicalDevice->GetVendorName().length() + 1;
    size_t architectureCLen = mPhysicalDevice->GetArchitectureName().length() + 1;
    size_t nameCLen = mPhysicalDevice->GetName().length() + 1;
    size_t driverDescriptionCLen = mPhysicalDevice->GetDriverDescription().length() + 1;

    // Allocate space for all strings.
    char* ptr = new char[vendorNameCLen + architectureCLen + nameCLen + driverDescriptionCLen];

    properties->vendorName = ptr;
    memcpy(ptr, mPhysicalDevice->GetVendorName().c_str(), vendorNameCLen);
    ptr += vendorNameCLen;

    properties->architecture = ptr;
    memcpy(ptr, mPhysicalDevice->GetArchitectureName().c_str(), architectureCLen);
    ptr += architectureCLen;

    properties->name = ptr;
    memcpy(ptr, mPhysicalDevice->GetName().c_str(), nameCLen);
    ptr += nameCLen;

    properties->driverDescription = ptr;
    memcpy(ptr, mPhysicalDevice->GetDriverDescription().c_str(), driverDescriptionCLen);
    ptr += driverDescriptionCLen;

    return wgpu::Status::Success;
}

void APIAdapterInfoFreeMembers(WGPUAdapterInfo info) {
    // This single delete is enough because everything is a single allocation.
    delete[] info.vendor;
}

void APIAdapterPropertiesFreeMembers(WGPUAdapterProperties properties) {
    // This single delete is enough because everything is a single allocation.
    delete[] properties.vendorName;
}

void APIAdapterPropertiesMemoryHeapsFreeMembers(
    WGPUAdapterPropertiesMemoryHeaps memoryHeapProperties) {
    delete[] memoryHeapProperties.heapInfo;
}

void APIDrmFormatCapabilitiesFreeMembers(WGPUDrmFormatCapabilities capabilities) {
    delete[] capabilities.properties;
}

bool AdapterBase::APIHasFeature(wgpu::FeatureName feature) const {
    return mSupportedFeatures.IsEnabled(feature);
}

size_t AdapterBase::APIEnumerateFeatures(wgpu::FeatureName* features) const {
    return mSupportedFeatures.EnumerateFeatures(features);
}

// TODO(https://crbug.com/dawn/2465) Could potentially re-implement via AllowSpontaneous async mode.
DeviceBase* AdapterBase::APICreateDevice(const DeviceDescriptor* descriptor) {
    if (descriptor == nullptr) {
        descriptor = &kDefaultDeviceDesc;
    }

    auto [lostEvent, result] = CreateDevice(descriptor);
    mInstance->GetEventManager()->TrackEvent(lostEvent);
    Ref<DeviceBase> device;
    if (mInstance->ConsumedError(std::move(result), &device)) {
        return nullptr;
    }
    return ReturnToAPI(std::move(device));
}

ResultOrError<Ref<DeviceBase>> AdapterBase::CreateDeviceInternal(
    const DeviceDescriptor* rawDescriptor,
    Ref<DeviceBase::DeviceLostEvent> lostEvent) {
    DAWN_ASSERT(rawDescriptor != nullptr);

    // Create device toggles state from required toggles descriptor and inherited adapter toggles
    // state.
    UnpackedPtr<DeviceDescriptor> descriptor;
    DAWN_TRY_ASSIGN(descriptor, ValidateAndUnpack(rawDescriptor));
    auto* deviceTogglesDesc = descriptor.Get<DawnTogglesDescriptor>();

    // Create device toggles state.
    TogglesState deviceToggles =
        TogglesState::CreateFromTogglesDescriptor(deviceTogglesDesc, ToggleStage::Device);
    deviceToggles.InheritFrom(mTogglesState);
    // Default toggles for all backend
    deviceToggles.Default(Toggle::LazyClearResourceOnFirstUse, true);
    deviceToggles.Default(Toggle::TimestampQuantization, true);
    if (mInstance->IsBackendValidationEnabled()) {
        deviceToggles.Default(Toggle::UseUserDefinedLabelsInBackend, true);
    }

    // Backend-specific forced and default device toggles
    mPhysicalDevice->SetupBackendDeviceToggles(mInstance->GetPlatform(), &deviceToggles);

    std::unordered_set<wgpu::FeatureName> requiredFeatureSet;
    for (uint32_t i = 0; i < descriptor->requiredFeatureCount; ++i) {
        requiredFeatureSet.insert(descriptor->requiredFeatures[i]);
    }
    // Validate all required features are supported by the adapter and suitable under device
    // toggles. Note that certain toggles in device toggles state may be overridden by user and
    // different from the adapter toggles state, and in this case a device may support features
    // that not supported by the adapter. We allow such toggles overriding for the convenience e.g.
    // creating a device for internal usage with AllowUnsafeAPI enabled from an adapter that
    // disabled AllowUnsafeAPIS.
    for (wgpu::FeatureName requiredFeature : requiredFeatureSet) {
        // TODO(349125474): Remove deprecated ChromiumExperimentalSubgroups.
        if (requiredFeature == wgpu::FeatureName::ChromiumExperimentalSubgroups) {
            GetInstance()->EmitDeprecationWarning(
                "Feature chromium-experimental-subgroups is deprecated. Use features subgroups and "
                "subgroups-f16 instead.");
        }
        FeatureValidationResult result =
            mPhysicalDevice->ValidateFeatureSupportedWithToggles(requiredFeature, deviceToggles);
        DAWN_INVALID_IF(!result.success, "Invalid feature required: %s",
                        result.errorMessage.c_str());
    }

    if (descriptor->requiredLimits != nullptr) {
        // Only consider limits in RequiredLimits structure, and currently no chained structure
        // supported.
        DAWN_INVALID_IF(descriptor->requiredLimits->nextInChain != nullptr,
                        "can not chain after requiredLimits.");

        SupportedLimits supportedLimits;
        wgpu::Status status = APIGetLimits(&supportedLimits);
        DAWN_ASSERT(status == wgpu::Status::Success);

        DAWN_TRY_CONTEXT(ValidateLimits(supportedLimits.limits, descriptor->requiredLimits->limits),
                         "validating required limits");
    }

    return mPhysicalDevice->CreateDevice(this, descriptor, deviceToggles, std::move(lostEvent));
}

std::pair<Ref<DeviceBase::DeviceLostEvent>, ResultOrError<Ref<DeviceBase>>>
AdapterBase::CreateDevice(const DeviceDescriptor* descriptor) {
    DAWN_ASSERT(descriptor != nullptr);

    Ref<DeviceBase::DeviceLostEvent> lostEvent = DeviceBase::DeviceLostEvent::Create(descriptor);

    auto result = CreateDeviceInternal(descriptor, lostEvent);
    if (result.IsError()) {
        lostEvent->mReason = wgpu::DeviceLostReason::FailedCreation;
        lostEvent->mMessage = "Failed to create device.";
        mInstance->GetEventManager()->SetFutureReady(lostEvent.Get());
    }
    return {lostEvent, std::move(result)};
}

void AdapterBase::APIRequestDevice(const DeviceDescriptor* descriptor,
                                   WGPURequestDeviceCallback callback,
                                   void* userdata) {
    // Default legacy callback mode for RequestDevice is spontaneous.
    APIRequestDeviceF(descriptor,
                      {nullptr, wgpu::CallbackMode::AllowSpontaneous, callback, userdata});
}

Future AdapterBase::APIRequestDeviceF(const DeviceDescriptor* descriptor,
                                      const RequestDeviceCallbackInfo& callbackInfo) {
    return APIRequestDevice2(
        descriptor, {ToAPI(callbackInfo.nextInChain), ToAPI(callbackInfo.mode),
                     [](WGPURequestDeviceStatus status, WGPUDevice device, char const* message,
                        void* callback, void* userdata) {
                         auto cb = reinterpret_cast<WGPURequestDeviceCallback>(callback);
                         cb(status, device, message, userdata);
                     },
                     reinterpret_cast<void*>(callbackInfo.callback), callbackInfo.userdata});
}

Future AdapterBase::APIRequestDevice2(const DeviceDescriptor* descriptor,
                                      const WGPURequestDeviceCallbackInfo2& callbackInfo) {
    struct RequestDeviceEvent final : public EventManager::TrackedEvent {
        WGPURequestDeviceCallback2 mCallback;
        raw_ptr<void> mUserdata1;
        raw_ptr<void> mUserdata2;

        WGPURequestDeviceStatus mStatus;
        Ref<DeviceBase> mDevice = nullptr;
        std::string mMessage;

        RequestDeviceEvent(const WGPURequestDeviceCallbackInfo2& callbackInfo,
                           Ref<DeviceBase> device)
            : TrackedEvent(static_cast<wgpu::CallbackMode>(callbackInfo.mode),
                           TrackedEvent::Completed{}),
              mCallback(callbackInfo.callback),
              mUserdata1(callbackInfo.userdata1),
              mUserdata2(callbackInfo.userdata2),
              mStatus(WGPURequestDeviceStatus_Success),
              mDevice(std::move(device)) {}

        RequestDeviceEvent(const WGPURequestDeviceCallbackInfo2& callbackInfo,
                           const std::string& message)
            : TrackedEvent(static_cast<wgpu::CallbackMode>(callbackInfo.mode),
                           TrackedEvent::Completed{}),
              mCallback(callbackInfo.callback),
              mUserdata1(callbackInfo.userdata1),
              mUserdata2(callbackInfo.userdata2),
              mStatus(WGPURequestDeviceStatus_Error),
              mMessage(message) {}

        ~RequestDeviceEvent() override { EnsureComplete(EventCompletionType::Shutdown); }

        void Complete(EventCompletionType completionType) override {
            if (completionType == EventCompletionType::Shutdown) {
                mStatus = WGPURequestDeviceStatus_InstanceDropped;
                mDevice = nullptr;
                mMessage = "A valid external Instance reference no longer exists.";
            }
            mCallback(mStatus, ToAPI(ReturnToAPI(std::move(mDevice))),
                      mMessage.empty() ? nullptr : mMessage.c_str(), mUserdata1.ExtractAsDangling(),
                      mUserdata2.ExtractAsDangling());
        }
    };

    if (descriptor == nullptr) {
        descriptor = &kDefaultDeviceDesc;
    }

    FutureID futureID = kNullFutureID;
    auto [lostEvent, result] = CreateDevice(descriptor);
    if (result.IsSuccess()) {
        futureID = mInstance->GetEventManager()->TrackEvent(
            AcquireRef(new RequestDeviceEvent(callbackInfo, result.AcquireSuccess())));
    } else {
        futureID = mInstance->GetEventManager()->TrackEvent(AcquireRef(
            new RequestDeviceEvent(callbackInfo, result.AcquireError()->GetFormattedMessage())));
    }
    mInstance->GetEventManager()->TrackEvent(std::move(lostEvent));
    return {futureID};
}

wgpu::Status AdapterBase::APIGetFormatCapabilities(wgpu::TextureFormat format,
                                                   FormatCapabilities* capabilities) {
    if (!mSupportedFeatures.IsEnabled(wgpu::FeatureName::FormatCapabilities)) {
        [[maybe_unused]] bool hadError = mInstance->ConsumedError(
            DAWN_VALIDATION_ERROR("Feature FormatCapabilities is not available."));
        return wgpu::Status::Error;
    }
    DAWN_ASSERT(capabilities != nullptr);

    UnpackedPtr<FormatCapabilities> unpacked;
    if (mInstance->ConsumedError(ValidateAndUnpack(capabilities), &unpacked)) {
        return wgpu::Status::Error;
    }

    if (unpacked.Get<DrmFormatCapabilities>() != nullptr &&
        !mSupportedFeatures.IsEnabled(wgpu::FeatureName::DrmFormatCapabilities)) {
        [[maybe_unused]] bool hadError = mInstance->ConsumedError(
            DAWN_VALIDATION_ERROR("Feature DrmFormatCapabilities is not available."));
        return wgpu::Status::Error;
    }

    mPhysicalDevice->PopulateBackendFormatCapabilities(format, unpacked);
    return wgpu::Status::Success;
}

const TogglesState& AdapterBase::GetTogglesState() const {
    return mTogglesState;
}

FeatureLevel AdapterBase::GetFeatureLevel() const {
    return mFeatureLevel;
}

const std::string& AdapterBase::GetName() const {
    return mPhysicalDevice->GetName();
}

std::vector<Ref<AdapterBase>> SortAdapters(std::vector<Ref<AdapterBase>> adapters,
                                           const RequestAdapterOptions* options) {
    const bool highPerformance =
        options != nullptr && options->powerPreference == wgpu::PowerPreference::HighPerformance;

    const auto ComputeAdapterTypeRank = [&](const Ref<AdapterBase>& a) {
        switch (a->GetPhysicalDevice()->GetAdapterType()) {
            case wgpu::AdapterType::DiscreteGPU:
                return highPerformance ? 0 : 1;
            case wgpu::AdapterType::IntegratedGPU:
                return highPerformance ? 1 : 0;
            case wgpu::AdapterType::CPU:
                return 2;
            case wgpu::AdapterType::Unknown:
                return 3;
        }
        DAWN_UNREACHABLE();
    };

    const auto ComputeBackendTypeRank = [](const Ref<AdapterBase>& a) {
        switch (a->GetPhysicalDevice()->GetBackendType()) {
            // Sort backends generally in order of Core -> Compat -> Testing,
            // while preferring OS-specific backends like Metal/D3D.
            case wgpu::BackendType::Metal:
            case wgpu::BackendType::D3D12:
                return 0;
            case wgpu::BackendType::Vulkan:
                return 1;
            case wgpu::BackendType::D3D11:
                return 2;
            case wgpu::BackendType::OpenGLES:
                return 3;
            case wgpu::BackendType::OpenGL:
                return 4;
            case wgpu::BackendType::WebGPU:
                return 5;
            case wgpu::BackendType::Null:
                return 6;
            case wgpu::BackendType::Undefined:
                break;
        }
        DAWN_UNREACHABLE();
    };

    std::sort(adapters.begin(), adapters.end(),
              [&](const Ref<AdapterBase>& a, const Ref<AdapterBase>& b) -> bool {
                  return std::tuple(ComputeAdapterTypeRank(a), ComputeBackendTypeRank(a)) <
                         std::tuple(ComputeAdapterTypeRank(b), ComputeBackendTypeRank(b));
              });

    return adapters;
}

}  // namespace dawn::native
