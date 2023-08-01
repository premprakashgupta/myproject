# Add WebRTC specific rules
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# If you are using Firebase Analytics or other Firebase features
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# Add any other custom ProGuard rules for your project here
