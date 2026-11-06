if [ "$CONFIGURATION" == "Debug-diffdev" ] || [ "$CONFIGURATION" == "Release-diffdev" ]; then
  cp Runner/diffdev/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-dev" ] || [ "$CONFIGURATION" == "Release-dev" ]; then
  cp Runner/dev/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-diffsit" ] || [ "$CONFIGURATION" == "Release-diffsit" ]; then
  cp Runner/diffsit/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-sit" ] || [ "$CONFIGURATION" == "Release-sit" ]; then
  cp Runner/sit/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-diffuat" ] || [ "$CONFIGURATION" == "Release-diffuat" ]; then
  cp Runner/diffuat/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-uat" ] || [ "$CONFIGURATION" == "Release-uat" ]; then
  cp Runner/uat/GoogleService-Info.plist Runner/GoogleService-Info.plist
elif [ "$CONFIGURATION" == "Debug-prod" ] || [ "$CONFIGURATION" == "Release-prod" ]; then
  cp Runner/prod/GoogleService-Info.plist Runner/GoogleService-Info.plist
fi

