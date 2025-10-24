-keep class com.paytm.pgsdk.** { *; }
-keep class easypay.* { *; }
-keep class android.support.v7.widget.* { *; }
-dontwarn android.support.v7.widget.*

-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}

# Stripe Push Provisioning classes
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-dontwarn com.reactnativestripesdk.pushprovisioning.**
