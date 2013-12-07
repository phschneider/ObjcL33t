#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "CrittercismSDK/CrittercismSDK/dsym_upload.sh"
install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal.png"
install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal@2x.png"
install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected.png"
install_resource "StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected@2x.png"
install_resource "apptentive-ios/ApptentiveResources.bundle"
install_resource "iRate/iRate/iRate.bundle"
install_resource "uservoice-iphone-sdk/Resources/uv_article.png"
install_resource "uservoice-iphone-sdk/Resources/uv_article@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_default_avatar.png"
install_resource "uservoice-iphone-sdk/Resources/uv_default_avatar@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_idea.png"
install_resource "uservoice-iphone-sdk/Resources/uv_idea@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_logo.png"
install_resource "uservoice-iphone-sdk/Resources/uv_logo@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_vote_chicklet.png"
install_resource "uservoice-iphone-sdk/Resources/uv_vote_chicklet@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_vote_chicklet_empty.png"
install_resource "uservoice-iphone-sdk/Resources/uv_vote_chicklet_empty@2x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_x.png"
install_resource "uservoice-iphone-sdk/Resources/uv_x@2x.png"
install_resource "uservoice-iphone-sdk/Resources/ca.lproj"
install_resource "uservoice-iphone-sdk/Resources/cs.lproj"
install_resource "uservoice-iphone-sdk/Resources/da.lproj"
install_resource "uservoice-iphone-sdk/Resources/de.lproj"
install_resource "uservoice-iphone-sdk/Resources/el.lproj"
install_resource "uservoice-iphone-sdk/Resources/en-GB.lproj"
install_resource "uservoice-iphone-sdk/Resources/en.lproj"
install_resource "uservoice-iphone-sdk/Resources/es.lproj"
install_resource "uservoice-iphone-sdk/Resources/fi.lproj"
install_resource "uservoice-iphone-sdk/Resources/fr.lproj"
install_resource "uservoice-iphone-sdk/Resources/hr.lproj"
install_resource "uservoice-iphone-sdk/Resources/hu.lproj"
install_resource "uservoice-iphone-sdk/Resources/id.lproj"
install_resource "uservoice-iphone-sdk/Resources/it.lproj"
install_resource "uservoice-iphone-sdk/Resources/ja.lproj"
install_resource "uservoice-iphone-sdk/Resources/ko.lproj"
install_resource "uservoice-iphone-sdk/Resources/ms.lproj"
install_resource "uservoice-iphone-sdk/Resources/nb.lproj"
install_resource "uservoice-iphone-sdk/Resources/nl.lproj"
install_resource "uservoice-iphone-sdk/Resources/pl.lproj"
install_resource "uservoice-iphone-sdk/Resources/pt-PT.lproj"
install_resource "uservoice-iphone-sdk/Resources/pt.lproj"
install_resource "uservoice-iphone-sdk/Resources/ro.lproj"
install_resource "uservoice-iphone-sdk/Resources/ru.lproj"
install_resource "uservoice-iphone-sdk/Resources/sk.lproj"
install_resource "uservoice-iphone-sdk/Resources/sv.lproj"
install_resource "uservoice-iphone-sdk/Resources/th.lproj"
install_resource "uservoice-iphone-sdk/Resources/tr.lproj"
install_resource "uservoice-iphone-sdk/Resources/uk.lproj"
install_resource "uservoice-iphone-sdk/Resources/vi.lproj"
install_resource "uservoice-iphone-sdk/Resources/zh-Hans.lproj"
install_resource "uservoice-iphone-sdk/Resources/zh-Hant.lproj"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"
