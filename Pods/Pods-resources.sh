#!/bin/sh

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy.txt
touch "$RESOURCES_TO_COPY"

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
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource 'SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle'
install_resource 'StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal.png'
install_resource 'StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-normal@2x.png'
install_resource 'StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected.png'
install_resource 'StyledPageControl/StyledPageControlDemo/PageControlDemo/Resources/pagecontrol-thumb-selected@2x.png'
install_resource 'iRate/iRate/iRate.bundle'
install_resource 'uservoice-iphone-sdk/Resources/uv_article.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_article@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_default_avatar.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_default_avatar@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_idea.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_idea@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_logo.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_logo@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_vote_chicklet.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_vote_chicklet@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_vote_chicklet_empty.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_vote_chicklet_empty@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_x.png'
install_resource 'uservoice-iphone-sdk/Resources/uv_x@2x.png'
install_resource 'uservoice-iphone-sdk/Resources/de.lproj'
install_resource 'uservoice-iphone-sdk/Resources/en.lproj'
install_resource 'uservoice-iphone-sdk/Resources/fr.lproj'
install_resource 'uservoice-iphone-sdk/Resources/it.lproj'
install_resource 'uservoice-iphone-sdk/Resources/nl.lproj'
install_resource 'uservoice-iphone-sdk/Resources/zh-Hant.lproj'

rsync -avr --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rm "$RESOURCES_TO_COPY"
