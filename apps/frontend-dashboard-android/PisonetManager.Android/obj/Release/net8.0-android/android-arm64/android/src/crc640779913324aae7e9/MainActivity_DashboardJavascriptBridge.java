package crc640779913324aae7e9;


public class MainActivity_DashboardJavascriptBridge
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_PostMessage:(Ljava/lang/String;)V:__export__\n" +
			"";
		mono.android.Runtime.register ("PisonetManager.Android.MainActivity+DashboardJavascriptBridge, PisonetManager.Android", MainActivity_DashboardJavascriptBridge.class, __md_methods);
	}


	public MainActivity_DashboardJavascriptBridge ()
	{
		super ();
		if (getClass () == MainActivity_DashboardJavascriptBridge.class) {
			mono.android.TypeManager.Activate ("PisonetManager.Android.MainActivity+DashboardJavascriptBridge, PisonetManager.Android", "", this, new java.lang.Object[] {  });
		}
	}

	public MainActivity_DashboardJavascriptBridge (crc640779913324aae7e9.MainActivity p0)
	{
		super ();
		if (getClass () == MainActivity_DashboardJavascriptBridge.class) {
			mono.android.TypeManager.Activate ("PisonetManager.Android.MainActivity+DashboardJavascriptBridge, PisonetManager.Android", "PisonetManager.Android.MainActivity, PisonetManager.Android", this, new java.lang.Object[] { p0 });
		}
	}

	@android.webkit.JavascriptInterface

	public void postMessage (java.lang.String p0)
	{
		n_PostMessage (p0);
	}

	private native void n_PostMessage (java.lang.String p0);

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
