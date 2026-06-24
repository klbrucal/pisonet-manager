package crc640779913324aae7e9;


public class MainActivity_DashboardWebChromeClient
	extends android.webkit.WebChromeClient
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onJsConfirm:(Landroid/webkit/WebView;Ljava/lang/String;Ljava/lang/String;Landroid/webkit/JsResult;)Z:GetOnJsConfirm_Landroid_webkit_WebView_Ljava_lang_String_Ljava_lang_String_Landroid_webkit_JsResult_Handler\n" +
			"";
		mono.android.Runtime.register ("PisonetManager.Android.MainActivity+DashboardWebChromeClient, PisonetManager.Android", MainActivity_DashboardWebChromeClient.class, __md_methods);
	}


	public MainActivity_DashboardWebChromeClient ()
	{
		super ();
		if (getClass () == MainActivity_DashboardWebChromeClient.class) {
			mono.android.TypeManager.Activate ("PisonetManager.Android.MainActivity+DashboardWebChromeClient, PisonetManager.Android", "", this, new java.lang.Object[] {  });
		}
	}

	public MainActivity_DashboardWebChromeClient (crc640779913324aae7e9.MainActivity p0)
	{
		super ();
		if (getClass () == MainActivity_DashboardWebChromeClient.class) {
			mono.android.TypeManager.Activate ("PisonetManager.Android.MainActivity+DashboardWebChromeClient, PisonetManager.Android", "PisonetManager.Android.MainActivity, PisonetManager.Android", this, new java.lang.Object[] { p0 });
		}
	}


	public boolean onJsConfirm (android.webkit.WebView p0, java.lang.String p1, java.lang.String p2, android.webkit.JsResult p3)
	{
		return n_onJsConfirm (p0, p1, p2, p3);
	}

	private native boolean n_onJsConfirm (android.webkit.WebView p0, java.lang.String p1, java.lang.String p2, android.webkit.JsResult p3);

	private java.util.ArrayList refList;
	public void monodroidAddReference (java.lang.Object obj)
	{
		if (refList == null)
			refList = new java.util.ArrayList ();
		refList.add (obj);
	}

	public void monodroidClearReferences ()
	{
		if (refList != null)
			refList.clear ();
	}
}
