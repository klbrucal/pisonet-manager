; ModuleID = 'typemaps.x86.ll'
source_filename = "typemaps.x86.ll"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i686-unknown-linux-android21"

%struct.TypeMapJava = type {
	i32, ; uint32_t module_index
	i32, ; uint32_t type_token_id
	i32 ; uint32_t java_name_index
}

%struct.TypeMapModule = type {
	[16 x i8], ; uint8_t module_uuid[16]
	i32, ; uint32_t entry_count
	i32, ; uint32_t duplicate_count
	ptr, ; TypeMapModuleEntry map
	ptr, ; TypeMapModuleEntry duplicate_map
	ptr, ; char* assembly_name
	ptr, ; MonoImage image
	i32, ; uint32_t java_name_width
	ptr ; uint8_t java_map
}

%struct.TypeMapModuleEntry = type {
	i32, ; uint32_t type_token_id
	i32 ; uint32_t java_map_index
}

@map_module_count = dso_local local_unnamed_addr constant i32 2, align 4

@java_type_count = dso_local local_unnamed_addr constant i32 171, align 4

; Managed modules map
@map_modules = dso_local local_unnamed_addr global [2 x %struct.TypeMapModule] [
	%struct.TypeMapModule {
		[16 x i8] c"\02\EA\9A=\FD`\03F\90>:\AA\CE\88\8D\8E", ; module_uuid: 3d9aea02-60fd-4603-903e-3aaace888d8e
		i32 4, ; uint32_t entry_count (0x4)
		i32 0, ; uint32_t duplicate_count (0x0)
		ptr @module0_managed_to_java, ; TypeMapModuleEntry* map
		ptr null, ; TypeMapModuleEntry* duplicate_map
		ptr @.TypeMapModule.0_assembly_name, ; assembly_name: PisonetManager.Android
		ptr null, ; MonoImage* image
		i32 0, ; uint32_t java_name_width (0x0)
		ptr null; uint8_t* java_map (0x0)
	}, ; 0
	%struct.TypeMapModule {
		[16 x i8] c"&sV\22\81B[D\AE\CA\94?\1D\E8\8E)", ; module_uuid: 22567326-4281-445b-aeca-943f1de88e29
		i32 167, ; uint32_t entry_count (0xa7)
		i32 63, ; uint32_t duplicate_count (0x3f)
		ptr @module1_managed_to_java, ; TypeMapModuleEntry* map
		ptr @module1_managed_to_java_duplicates, ; TypeMapModuleEntry* duplicate_map
		ptr @.TypeMapModule.1_assembly_name, ; assembly_name: Mono.Android
		ptr null, ; MonoImage* image
		i32 0, ; uint32_t java_name_width (0x0)
		ptr null; uint8_t* java_map (0x0)
	} ; 1
], align 4

; Java types name hashes
@map_java_hashes = dso_local local_unnamed_addr constant [171 x i32] [
	i32 12341354, ; 0: 0xbc506a => java/lang/Object
	i32 32078366, ; 1: 0x1e97a1e => java/security/cert/Certificate
	i32 74282880, ; 2: 0x46d7780 => android/view/ViewGroup
	i32 118977103, ; 3: 0x717724f => android/util/DisplayMetrics
	i32 138171443, ; 4: 0x83c5433 => javax/net/ssl/SSLSessionContext
	i32 139280357, ; 5: 0x84d3fe5 => android/view/KeyEvent
	i32 176697843, ; 6: 0xa8831f3 => java/lang/IllegalArgumentException
	i32 182466543, ; 7: 0xae037ef => crc640779913324aae7e9/MainActivity_DashboardJavascriptBridge
	i32 269199815, ; 8: 0x100ba9c7 => javax/security/cert/X509Certificate
	i32 279693177, ; 9: 0x10abc779 => android/content/SharedPreferences$Editor
	i32 363230265, ; 10: 0x15a67439 => crc640779913324aae7e9/MainActivity_DashboardWebChromeClient
	i32 366534601, ; 11: 0x15d8dfc9 => android/view/ViewGroup$LayoutParams
	i32 393371378, ; 12: 0x17725ef2 => mono/java/lang/RunnableImplementor
	i32 412771173, ; 13: 0x189a6365 => java/lang/Long
	i32 419359493, ; 14: 0x18feeb05 => java/util/Iterator
	i32 420482824, ; 15: 0x19100f08 => java/net/ConnectException
	i32 434958167, ; 16: 0x19ecef57 => android/runtime/XmlReaderPullParser
	i32 467220734, ; 17: 0x1bd938fe => android/widget/AbsSpinner
	i32 501733478, ; 18: 0x1de7d866 => android/view/ViewGroup$MarginLayoutParams
	i32 517668398, ; 19: 0x1edafe2e => android/os/Parcel
	i32 531198748, ; 20: 0x1fa9731c => mono/android/runtime/OutputStreamAdapter
	i32 581097368, ; 21: 0x22a2d798 => java/nio/channels/FileChannel
	i32 584231583, ; 22: 0x22d2aa9f => java/lang/IllegalStateException
	i32 591810476, ; 23: 0x23464fac => android/os/Bundle
	i32 598201240, ; 24: 0x23a7d398 => android/app/Notification
	i32 619060219, ; 25: 0x24e61bfb => java/net/URL
	i32 660298094, ; 26: 0x275b596e => crc640779913324aae7e9/MainActivity_DashboardWebViewClient
	i32 692920175, ; 27: 0x294d1f6f => java/util/ArrayList
	i32 780408360, ; 28: 0x2e841628 => java/lang/CharSequence
	i32 780987551, ; 29: 0x2e8cec9f => java/io/PrintWriter
	i32 793918146, ; 30: 0x2f523ac2 => java/lang/Integer
	i32 805498755, ; 31: 0x3002ef83 => android/os/IBinder$DeathRecipient
	i32 806800039, ; 32: 0x3016caa7 => java/lang/Thread
	i32 838682992, ; 33: 0x31fd4970 => java/lang/NullPointerException
	i32 876646173, ; 34: 0x34408f1d => javax/net/ssl/TrustManager
	i32 893363610, ; 35: 0x353fa59a => java/lang/Short
	i32 996699600, ; 36: 0x3b686dd0 => java/io/FileDescriptor
	i32 1018791985, ; 37: 0x3cb98831 => android/widget/EditText
	i32 1026507328, ; 38: 0x3d2f4240 => java/net/SocketAddress
	i32 1030707578, ; 39: 0x3d6f597a => android/database/DataSetObserver
	i32 1035992969, ; 40: 0x3dbfff89 => android/content/res/Resources
	i32 1055644286, ; 41: 0x3eebda7e => android/widget/AbsoluteLayout
	i32 1077629184, ; 42: 0x403b5100 => java/util/function/Consumer
	i32 1090939588, ; 43: 0x41066ac4 => javax/net/ssl/KeyManagerFactory
	i32 1100963717, ; 44: 0x419f5f85 => android/widget/TextView$OnEditorActionListener
	i32 1142011573, ; 45: 0x4411b6b5 => java/util/Enumeration
	i32 1173664585, ; 46: 0x45f4b349 => android/app/NotificationChannel
	i32 1227075600, ; 47: 0x4923b010 => javax/security/cert/Certificate
	i32 1270561450, ; 48: 0x4bbb3aaa => java/net/SocketTimeoutException
	i32 1298454265, ; 49: 0x4d64d6f9 => java/lang/Throwable
	i32 1323697755, ; 50: 0x4ee6065b => javax/net/ssl/SSLContext
	i32 1335098580, ; 51: 0x4f93fcd4 => java/util/Collection
	i32 1368421702, ; 52: 0x51907546 => java/lang/ClassCastException
	i32 1373631042, ; 53: 0x51dff242 => javax/net/ssl/KeyManager
	i32 1425790689, ; 54: 0x54fbd6e1 => java/lang/SecurityException
	i32 1428048664, ; 55: 0x551e4b18 => java/net/HttpURLConnection
	i32 1447309214, ; 56: 0x56442f9e => android/widget/LinearLayout$LayoutParams
	i32 1459844378, ; 57: 0x5703751a => android/widget/ProgressBar
	i32 1465931843, ; 58: 0x57605843 => android/app/Notification$Builder
	i32 1475682991, ; 59: 0x57f522af => java/util/HashMap
	i32 1476293262, ; 60: 0x57fe728e => javax/security/auth/Subject
	i32 1489594546, ; 61: 0x58c968b2 => java/nio/channels/spi/AbstractInterruptibleChannel
	i32 1506774891, ; 62: 0x59cf8f6b => android/widget/Button
	i32 1573833883, ; 63: 0x5dcecc9b => android/app/AlertDialog
	i32 1586851388, ; 64: 0x5e956e3c => android/os/Handler
	i32 1622360015, ; 65: 0x60b33fcf => android/webkit/CookieManager
	i32 1637959351, ; 66: 0x61a146b7 => java/security/Principal
	i32 1646348278, ; 67: 0x622147f6 => android/view/View
	i32 1649695927, ; 68: 0x62545cb7 => java/lang/RuntimeException
	i32 1657134862, ; 69: 0x62c5df0e => java/lang/IndexOutOfBoundsException
	i32 1661912031, ; 70: 0x630ec3df => android/view/View$OnTouchListener
	i32 1680835779, ; 71: 0x642f84c3 => java/lang/Byte
	i32 1718265030, ; 72: 0x666aa4c6 => java/lang/Character
	i32 1740814247, ; 73: 0x67c2b7a7 => android/widget/FrameLayout
	i32 1740929322, ; 74: 0x67c4792a => android/os/IInterface
	i32 1755285137, ; 75: 0x689f8691 => java/util/Random
	i32 1758490869, ; 76: 0x68d070f5 => android/os/BaseBundle
	i32 1807220671, ; 77: 0x6bb7ffbf => android/view/View$OnClickListener
	i32 1851730788, ; 78: 0x6e5f2b64 => java/lang/Runnable
	i32 1859010077, ; 79: 0x6ece3e1d => android/widget/LinearLayout
	i32 1944129628, ; 80: 0x73e1105c => java/io/OutputStream
	i32 1985929388, ; 81: 0x765ee0ac => android/app/Activity
	i32 1987841337, ; 82: 0x767c0d39 => java/lang/Boolean
	i32 2008064836, ; 83: 0x77b0a344 => android/content/Intent
	i32 2026619833, ; 84: 0x78cbc3b9 => android/widget/FrameLayout$LayoutParams
	i32 2027782872, ; 85: 0x78dd82d8 => android/view/ContextThemeWrapper
	i32 2031450615, ; 86: 0x791579f7 => android/widget/AdapterView
	i32 2036556174, ; 87: 0x7963618e => android/content/DialogInterface
	i32 2064723667, ; 88: 0x7b112ed3 => android/widget/SpinnerAdapter
	i32 2073337312, ; 89: 0x7b949de0 => android/app/AlertDialog$Builder
	i32 2080685156, ; 90: 0x7c04bc64 => java/security/SecureRandom
	i32 2204262174, ; 91: 0x83625f1e => org/xmlpull/v1/XmlPullParser
	i32 2269094561, ; 92: 0x873fa2a1 => java/net/UnknownServiceException
	i32 2270923754, ; 93: 0x875b8bea => java/net/Proxy$Type
	i32 2284656609, ; 94: 0x882d17e1 => android/app/Application
	i32 2363729366, ; 95: 0x8ce3a5d6 => java/lang/Enum
	i32 2404057846, ; 96: 0x8f4b02f6 => android/app/PendingIntent
	i32 2411404453, ; 97: 0x8fbb1ca5 => java/lang/UnsupportedOperationException
	i32 2427098608, ; 98: 0x90aa95f0 => mono/android/widget/TextView_OnEditorActionListenerImplementor
	i32 2443438835, ; 99: 0x91a3eaf3 => java/net/SocketException
	i32 2461273673, ; 100: 0x92b40e49 => org/xmlpull/v1/XmlPullParserException
	i32 2484873381, ; 101: 0x941c28a5 => android/webkit/WebSettings
	i32 2511755332, ; 102: 0x95b65844 => android/app/NotificationManager
	i32 2532846927, ; 103: 0x96f82d4f => android/content/SharedPreferences$OnSharedPreferenceChangeListener
	i32 2558143838, ; 104: 0x987a2d5e => java/io/FileInputStream
	i32 2568863697, ; 105: 0x991dbfd1 => android/runtime/XmlReaderResourceParser
	i32 2594241228, ; 106: 0x9aa0facc => android/widget/BaseAdapter
	i32 2654672461, ; 107: 0x9e3b164d => java/io/InterruptedIOException
	i32 2664928003, ; 108: 0x9ed79303 => javax/net/ssl/HostnameVerifier
	i32 2675615863, ; 109: 0x9f7aa877 => android/webkit/WebViewClient
	i32 2681209703, ; 110: 0x9fd00367 => android/widget/Adapter
	i32 2681988174, ; 111: 0x9fdbe44e => android/view/MotionEvent
	i32 2687778660, ; 112: 0xa0343f64 => android/widget/TextView
	i32 2699556053, ; 113: 0xa0e7f4d5 => android/webkit/WebResourceRequest
	i32 2762684487, ; 114: 0xa4ab3847 => java/lang/Float
	i32 2815615939, ; 115: 0xa7d2e3c3 => android/os/Build
	i32 2836478263, ; 116: 0xa9113937 => android/widget/ScrollView
	i32 2874673969, ; 117: 0xab580b31 => java/lang/StackTraceElement
	i32 2918613155, ; 118: 0xadf680a3 => android/content/DialogInterface$OnClickListener
	i32 2932874700, ; 119: 0xaed01dcc => android/view/InputEvent
	i32 2933762856, ; 120: 0xaeddab28 => android/util/AttributeSet
	i32 2942792700, ; 121: 0xaf6773fc => java/lang/Exception
	i32 2980510762, ; 122: 0xb1a6fc2a => mono/android/runtime/JavaArray
	i32 2983720033, ; 123: 0xb1d7f461 => mono/android/TypeManager
	i32 2983793634, ; 124: 0xb1d913e2 => android/widget/Spinner
	i32 3032808825, ; 125: 0xb4c4fd79 => java/io/StringWriter
	i32 3173395525, ; 126: 0xbd262c45 => android/os/IBinder
	i32 3178304415, ; 127: 0xbd71139f => android/view/inputmethod/InputMethodManager
	i32 3203743976, ; 128: 0xbef540e8 => android/webkit/JsResult
	i32 3300906352, ; 129: 0xc4bfd570 => javax/net/ssl/SSLSession
	i32 3319735188, ; 130: 0xc5df2394 => java/net/Proxy
	i32 3397817114, ; 131: 0xca86931a => android/widget/ArrayAdapter
	i32 3409419575, ; 132: 0xcb379d37 => javax/net/ssl/HttpsURLConnection
	i32 3423467887, ; 133: 0xcc0df96f => java/lang/Number
	i32 3430868172, ; 134: 0xcc7ee4cc => android/content/SharedPreferences
	i32 3519931621, ; 135: 0xd1cde4e5 => java/net/URLConnection
	i32 3576242387, ; 136: 0xd52920d3 => android/runtime/JavaProxyThrowable
	i32 3666243682, ; 137: 0xda867062 => java/lang/String
	i32 3669061717, ; 138: 0xdab17055 => java/net/InetSocketAddress
	i32 3683323802, ; 139: 0xdb8b0f9a => mono/android/runtime/JavaObject
	i32 3702230909, ; 140: 0xdcab8f7d => java/lang/Double
	i32 3715861037, ; 141: 0xdd7b8a2d => android/os/Build$VERSION
	i32 3722843854, ; 142: 0xdde616ce => javax/net/SocketFactory
	i32 3726680736, ; 143: 0xde20a2a0 => java/net/ProtocolException
	i32 3738171500, ; 144: 0xdecff86c => android/webkit/WebChromeClient
	i32 3759929762, ; 145: 0xe01bf9a2 => android/graphics/Bitmap
	i32 3763853270, ; 146: 0xe057d7d6 => android/view/Window
	i32 3823421666, ; 147: 0xe3e4c8e2 => android/net/Uri
	i32 3865571169, ; 148: 0xe667ef61 => android/content/res/XmlResourceParser
	i32 3882570516, ; 149: 0xe76b5314 => java/lang/Class
	i32 3884080736, ; 150: 0xe7825e60 => android/webkit/WebView
	i32 3900328001, ; 151: 0xe87a4841 => android/graphics/Typeface
	i32 3900581163, ; 152: 0xe87e252b => java/io/InputStream
	i32 3906036904, ; 153: 0xe8d164a8 => android/webkit/ValueCallback
	i32 3912451735, ; 154: 0xe9334697 => java/security/KeyStore
	i32 3931120197, ; 155: 0xea502245 => mono/android/content/DialogInterface_OnClickListenerImplementor
	i32 3969984744, ; 156: 0xeca128e8 => mono/android/runtime/InputStreamAdapter
	i32 3970461676, ; 157: 0xeca86fec => crc640779913324aae7e9/MainActivity
	i32 3975001277, ; 158: 0xecedb4bd => javax/net/ssl/SSLSocketFactory
	i32 3993327007, ; 159: 0xee05559f => android/content/ContextWrapper
	i32 4020308495, ; 160: 0xefa10a0f => java/lang/Error
	i32 4030673356, ; 161: 0xf03f31cc => android/app/Dialog
	i32 4051772911, ; 162: 0xf18125ef => android/content/Context
	i32 4087518402, ; 163: 0xf3a294c2 => mono/android/view/View_OnTouchListenerImplementor
	i32 4088038176, ; 164: 0xf3aa8320 => java/io/Reader
	i32 4098107575, ; 165: 0xf44428b7 => mono/android/view/View_OnClickListenerImplementor
	i32 4101363546, ; 166: 0xf475d75a => java/io/Writer
	i32 4118878202, ; 167: 0xf58117fa => android/os/Looper
	i32 4148593869, ; 168: 0xf74684cd => javax/net/ssl/TrustManagerFactory
	i32 4157808693, ; 169: 0xf7d32035 => java/io/IOException
	i32 4232707919 ; 170: 0xfc49ff4f => java/util/HashSet
], align 4

@module0_managed_to_java = internal dso_local constant [4 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554435, ; uint32_t type_token_id (0x2000003)
		i32 157; uint32_t java_map_index (0x9d)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554437, ; uint32_t type_token_id (0x2000005)
		i32 26; uint32_t java_map_index (0x1a)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554438, ; uint32_t type_token_id (0x2000006)
		i32 10; uint32_t java_map_index (0xa)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554439, ; uint32_t type_token_id (0x2000007)
		i32 7; uint32_t java_map_index (0x7)
	} ; 3
], align 4

@module1_managed_to_java = internal dso_local constant [167 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554533, ; uint32_t type_token_id (0x2000065)
		i32 91; uint32_t java_map_index (0x5b)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554535, ; uint32_t type_token_id (0x2000067)
		i32 100; uint32_t java_map_index (0x64)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554537, ; uint32_t type_token_id (0x2000069)
		i32 47; uint32_t java_map_index (0x2f)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554539, ; uint32_t type_token_id (0x200006b)
		i32 8; uint32_t java_map_index (0x8)
	}, ; 3
	%struct.TypeMapModuleEntry {
		i32 33554541, ; uint32_t type_token_id (0x200006d)
		i32 60; uint32_t java_map_index (0x3c)
	}, ; 4
	%struct.TypeMapModuleEntry {
		i32 33554542, ; uint32_t type_token_id (0x200006e)
		i32 142; uint32_t java_map_index (0x8e)
	}, ; 5
	%struct.TypeMapModuleEntry {
		i32 33554544, ; uint32_t type_token_id (0x2000070)
		i32 132; uint32_t java_map_index (0x84)
	}, ; 6
	%struct.TypeMapModuleEntry {
		i32 33554546, ; uint32_t type_token_id (0x2000072)
		i32 108; uint32_t java_map_index (0x6c)
	}, ; 7
	%struct.TypeMapModuleEntry {
		i32 33554548, ; uint32_t type_token_id (0x2000074)
		i32 53; uint32_t java_map_index (0x35)
	}, ; 8
	%struct.TypeMapModuleEntry {
		i32 33554550, ; uint32_t type_token_id (0x2000076)
		i32 129; uint32_t java_map_index (0x81)
	}, ; 9
	%struct.TypeMapModuleEntry {
		i32 33554552, ; uint32_t type_token_id (0x2000078)
		i32 4; uint32_t java_map_index (0x4)
	}, ; 10
	%struct.TypeMapModuleEntry {
		i32 33554554, ; uint32_t type_token_id (0x200007a)
		i32 34; uint32_t java_map_index (0x22)
	}, ; 11
	%struct.TypeMapModuleEntry {
		i32 33554556, ; uint32_t type_token_id (0x200007c)
		i32 43; uint32_t java_map_index (0x2b)
	}, ; 12
	%struct.TypeMapModuleEntry {
		i32 33554557, ; uint32_t type_token_id (0x200007d)
		i32 50; uint32_t java_map_index (0x32)
	}, ; 13
	%struct.TypeMapModuleEntry {
		i32 33554558, ; uint32_t type_token_id (0x200007e)
		i32 158; uint32_t java_map_index (0x9e)
	}, ; 14
	%struct.TypeMapModuleEntry {
		i32 33554560, ; uint32_t type_token_id (0x2000080)
		i32 168; uint32_t java_map_index (0xa8)
	}, ; 15
	%struct.TypeMapModuleEntry {
		i32 33554561, ; uint32_t type_token_id (0x2000081)
		i32 41; uint32_t java_map_index (0x29)
	}, ; 16
	%struct.TypeMapModuleEntry {
		i32 33554562, ; uint32_t type_token_id (0x2000082)
		i32 17; uint32_t java_map_index (0x11)
	}, ; 17
	%struct.TypeMapModuleEntry {
		i32 33554564, ; uint32_t type_token_id (0x2000084)
		i32 86; uint32_t java_map_index (0x56)
	}, ; 18
	%struct.TypeMapModuleEntry {
		i32 33554566, ; uint32_t type_token_id (0x2000086)
		i32 131; uint32_t java_map_index (0x83)
	}, ; 19
	%struct.TypeMapModuleEntry {
		i32 33554567, ; uint32_t type_token_id (0x2000087)
		i32 106; uint32_t java_map_index (0x6a)
	}, ; 20
	%struct.TypeMapModuleEntry {
		i32 33554569, ; uint32_t type_token_id (0x2000089)
		i32 62; uint32_t java_map_index (0x3e)
	}, ; 21
	%struct.TypeMapModuleEntry {
		i32 33554570, ; uint32_t type_token_id (0x200008a)
		i32 37; uint32_t java_map_index (0x25)
	}, ; 22
	%struct.TypeMapModuleEntry {
		i32 33554571, ; uint32_t type_token_id (0x200008b)
		i32 73; uint32_t java_map_index (0x49)
	}, ; 23
	%struct.TypeMapModuleEntry {
		i32 33554572, ; uint32_t type_token_id (0x200008c)
		i32 84; uint32_t java_map_index (0x54)
	}, ; 24
	%struct.TypeMapModuleEntry {
		i32 33554573, ; uint32_t type_token_id (0x200008d)
		i32 110; uint32_t java_map_index (0x6e)
	}, ; 25
	%struct.TypeMapModuleEntry {
		i32 33554575, ; uint32_t type_token_id (0x200008f)
		i32 88; uint32_t java_map_index (0x58)
	}, ; 26
	%struct.TypeMapModuleEntry {
		i32 33554577, ; uint32_t type_token_id (0x2000091)
		i32 79; uint32_t java_map_index (0x4f)
	}, ; 27
	%struct.TypeMapModuleEntry {
		i32 33554578, ; uint32_t type_token_id (0x2000092)
		i32 56; uint32_t java_map_index (0x38)
	}, ; 28
	%struct.TypeMapModuleEntry {
		i32 33554579, ; uint32_t type_token_id (0x2000093)
		i32 57; uint32_t java_map_index (0x39)
	}, ; 29
	%struct.TypeMapModuleEntry {
		i32 33554580, ; uint32_t type_token_id (0x2000094)
		i32 116; uint32_t java_map_index (0x74)
	}, ; 30
	%struct.TypeMapModuleEntry {
		i32 33554581, ; uint32_t type_token_id (0x2000095)
		i32 124; uint32_t java_map_index (0x7c)
	}, ; 31
	%struct.TypeMapModuleEntry {
		i32 33554582, ; uint32_t type_token_id (0x2000096)
		i32 112; uint32_t java_map_index (0x70)
	}, ; 32
	%struct.TypeMapModuleEntry {
		i32 33554583, ; uint32_t type_token_id (0x2000097)
		i32 44; uint32_t java_map_index (0x2c)
	}, ; 33
	%struct.TypeMapModuleEntry {
		i32 33554586, ; uint32_t type_token_id (0x200009a)
		i32 98; uint32_t java_map_index (0x62)
	}, ; 34
	%struct.TypeMapModuleEntry {
		i32 33554593, ; uint32_t type_token_id (0x20000a1)
		i32 65; uint32_t java_map_index (0x41)
	}, ; 35
	%struct.TypeMapModuleEntry {
		i32 33554595, ; uint32_t type_token_id (0x20000a3)
		i32 153; uint32_t java_map_index (0x99)
	}, ; 36
	%struct.TypeMapModuleEntry {
		i32 33554597, ; uint32_t type_token_id (0x20000a5)
		i32 113; uint32_t java_map_index (0x71)
	}, ; 37
	%struct.TypeMapModuleEntry {
		i32 33554600, ; uint32_t type_token_id (0x20000a8)
		i32 128; uint32_t java_map_index (0x80)
	}, ; 38
	%struct.TypeMapModuleEntry {
		i32 33554601, ; uint32_t type_token_id (0x20000a9)
		i32 144; uint32_t java_map_index (0x90)
	}, ; 39
	%struct.TypeMapModuleEntry {
		i32 33554602, ; uint32_t type_token_id (0x20000aa)
		i32 101; uint32_t java_map_index (0x65)
	}, ; 40
	%struct.TypeMapModuleEntry {
		i32 33554604, ; uint32_t type_token_id (0x20000ac)
		i32 150; uint32_t java_map_index (0x96)
	}, ; 41
	%struct.TypeMapModuleEntry {
		i32 33554605, ; uint32_t type_token_id (0x20000ad)
		i32 109; uint32_t java_map_index (0x6d)
	}, ; 42
	%struct.TypeMapModuleEntry {
		i32 33554606, ; uint32_t type_token_id (0x20000ae)
		i32 3; uint32_t java_map_index (0x3)
	}, ; 43
	%struct.TypeMapModuleEntry {
		i32 33554607, ; uint32_t type_token_id (0x20000af)
		i32 120; uint32_t java_map_index (0x78)
	}, ; 44
	%struct.TypeMapModuleEntry {
		i32 33554610, ; uint32_t type_token_id (0x20000b2)
		i32 76; uint32_t java_map_index (0x4c)
	}, ; 45
	%struct.TypeMapModuleEntry {
		i32 33554611, ; uint32_t type_token_id (0x20000b3)
		i32 115; uint32_t java_map_index (0x73)
	}, ; 46
	%struct.TypeMapModuleEntry {
		i32 33554612, ; uint32_t type_token_id (0x20000b4)
		i32 141; uint32_t java_map_index (0x8d)
	}, ; 47
	%struct.TypeMapModuleEntry {
		i32 33554613, ; uint32_t type_token_id (0x20000b5)
		i32 23; uint32_t java_map_index (0x17)
	}, ; 48
	%struct.TypeMapModuleEntry {
		i32 33554614, ; uint32_t type_token_id (0x20000b6)
		i32 64; uint32_t java_map_index (0x40)
	}, ; 49
	%struct.TypeMapModuleEntry {
		i32 33554615, ; uint32_t type_token_id (0x20000b7)
		i32 31; uint32_t java_map_index (0x1f)
	}, ; 50
	%struct.TypeMapModuleEntry {
		i32 33554617, ; uint32_t type_token_id (0x20000b9)
		i32 126; uint32_t java_map_index (0x7e)
	}, ; 51
	%struct.TypeMapModuleEntry {
		i32 33554619, ; uint32_t type_token_id (0x20000bb)
		i32 74; uint32_t java_map_index (0x4a)
	}, ; 52
	%struct.TypeMapModuleEntry {
		i32 33554621, ; uint32_t type_token_id (0x20000bd)
		i32 167; uint32_t java_map_index (0xa7)
	}, ; 53
	%struct.TypeMapModuleEntry {
		i32 33554622, ; uint32_t type_token_id (0x20000be)
		i32 19; uint32_t java_map_index (0x13)
	}, ; 54
	%struct.TypeMapModuleEntry {
		i32 33554625, ; uint32_t type_token_id (0x20000c1)
		i32 147; uint32_t java_map_index (0x93)
	}, ; 55
	%struct.TypeMapModuleEntry {
		i32 33554627, ; uint32_t type_token_id (0x20000c3)
		i32 39; uint32_t java_map_index (0x27)
	}, ; 56
	%struct.TypeMapModuleEntry {
		i32 33554630, ; uint32_t type_token_id (0x20000c6)
		i32 81; uint32_t java_map_index (0x51)
	}, ; 57
	%struct.TypeMapModuleEntry {
		i32 33554631, ; uint32_t type_token_id (0x20000c7)
		i32 63; uint32_t java_map_index (0x3f)
	}, ; 58
	%struct.TypeMapModuleEntry {
		i32 33554632, ; uint32_t type_token_id (0x20000c8)
		i32 89; uint32_t java_map_index (0x59)
	}, ; 59
	%struct.TypeMapModuleEntry {
		i32 33554633, ; uint32_t type_token_id (0x20000c9)
		i32 94; uint32_t java_map_index (0x5e)
	}, ; 60
	%struct.TypeMapModuleEntry {
		i32 33554634, ; uint32_t type_token_id (0x20000ca)
		i32 161; uint32_t java_map_index (0xa1)
	}, ; 61
	%struct.TypeMapModuleEntry {
		i32 33554635, ; uint32_t type_token_id (0x20000cb)
		i32 24; uint32_t java_map_index (0x18)
	}, ; 62
	%struct.TypeMapModuleEntry {
		i32 33554636, ; uint32_t type_token_id (0x20000cc)
		i32 58; uint32_t java_map_index (0x3a)
	}, ; 63
	%struct.TypeMapModuleEntry {
		i32 33554637, ; uint32_t type_token_id (0x20000cd)
		i32 46; uint32_t java_map_index (0x2e)
	}, ; 64
	%struct.TypeMapModuleEntry {
		i32 33554638, ; uint32_t type_token_id (0x20000ce)
		i32 102; uint32_t java_map_index (0x66)
	}, ; 65
	%struct.TypeMapModuleEntry {
		i32 33554639, ; uint32_t type_token_id (0x20000cf)
		i32 96; uint32_t java_map_index (0x60)
	}, ; 66
	%struct.TypeMapModuleEntry {
		i32 33554645, ; uint32_t type_token_id (0x20000d5)
		i32 85; uint32_t java_map_index (0x55)
	}, ; 67
	%struct.TypeMapModuleEntry {
		i32 33554646, ; uint32_t type_token_id (0x20000d6)
		i32 119; uint32_t java_map_index (0x77)
	}, ; 68
	%struct.TypeMapModuleEntry {
		i32 33554648, ; uint32_t type_token_id (0x20000d8)
		i32 5; uint32_t java_map_index (0x5)
	}, ; 69
	%struct.TypeMapModuleEntry {
		i32 33554649, ; uint32_t type_token_id (0x20000d9)
		i32 111; uint32_t java_map_index (0x6f)
	}, ; 70
	%struct.TypeMapModuleEntry {
		i32 33554650, ; uint32_t type_token_id (0x20000da)
		i32 67; uint32_t java_map_index (0x43)
	}, ; 71
	%struct.TypeMapModuleEntry {
		i32 33554651, ; uint32_t type_token_id (0x20000db)
		i32 77; uint32_t java_map_index (0x4d)
	}, ; 72
	%struct.TypeMapModuleEntry {
		i32 33554653, ; uint32_t type_token_id (0x20000dd)
		i32 165; uint32_t java_map_index (0xa5)
	}, ; 73
	%struct.TypeMapModuleEntry {
		i32 33554654, ; uint32_t type_token_id (0x20000de)
		i32 70; uint32_t java_map_index (0x46)
	}, ; 74
	%struct.TypeMapModuleEntry {
		i32 33554657, ; uint32_t type_token_id (0x20000e1)
		i32 163; uint32_t java_map_index (0xa3)
	}, ; 75
	%struct.TypeMapModuleEntry {
		i32 33554663, ; uint32_t type_token_id (0x20000e7)
		i32 2; uint32_t java_map_index (0x2)
	}, ; 76
	%struct.TypeMapModuleEntry {
		i32 33554664, ; uint32_t type_token_id (0x20000e8)
		i32 11; uint32_t java_map_index (0xb)
	}, ; 77
	%struct.TypeMapModuleEntry {
		i32 33554665, ; uint32_t type_token_id (0x20000e9)
		i32 18; uint32_t java_map_index (0x12)
	}, ; 78
	%struct.TypeMapModuleEntry {
		i32 33554667, ; uint32_t type_token_id (0x20000eb)
		i32 146; uint32_t java_map_index (0x92)
	}, ; 79
	%struct.TypeMapModuleEntry {
		i32 33554672, ; uint32_t type_token_id (0x20000f0)
		i32 127; uint32_t java_map_index (0x7f)
	}, ; 80
	%struct.TypeMapModuleEntry {
		i32 33554695, ; uint32_t type_token_id (0x2000107)
		i32 156; uint32_t java_map_index (0x9c)
	}, ; 81
	%struct.TypeMapModuleEntry {
		i32 33554697, ; uint32_t type_token_id (0x2000109)
		i32 122; uint32_t java_map_index (0x7a)
	}, ; 82
	%struct.TypeMapModuleEntry {
		i32 33554699, ; uint32_t type_token_id (0x200010b)
		i32 51; uint32_t java_map_index (0x33)
	}, ; 83
	%struct.TypeMapModuleEntry {
		i32 33554701, ; uint32_t type_token_id (0x200010d)
		i32 59; uint32_t java_map_index (0x3b)
	}, ; 84
	%struct.TypeMapModuleEntry {
		i32 33554710, ; uint32_t type_token_id (0x2000116)
		i32 27; uint32_t java_map_index (0x1b)
	}, ; 85
	%struct.TypeMapModuleEntry {
		i32 33554712, ; uint32_t type_token_id (0x2000118)
		i32 139; uint32_t java_map_index (0x8b)
	}, ; 86
	%struct.TypeMapModuleEntry {
		i32 33554713, ; uint32_t type_token_id (0x2000119)
		i32 136; uint32_t java_map_index (0x88)
	}, ; 87
	%struct.TypeMapModuleEntry {
		i32 33554714, ; uint32_t type_token_id (0x200011a)
		i32 170; uint32_t java_map_index (0xaa)
	}, ; 88
	%struct.TypeMapModuleEntry {
		i32 33554727, ; uint32_t type_token_id (0x2000127)
		i32 20; uint32_t java_map_index (0x14)
	}, ; 89
	%struct.TypeMapModuleEntry {
		i32 33554736, ; uint32_t type_token_id (0x2000130)
		i32 105; uint32_t java_map_index (0x69)
	}, ; 90
	%struct.TypeMapModuleEntry {
		i32 33554737, ; uint32_t type_token_id (0x2000131)
		i32 16; uint32_t java_map_index (0x10)
	}, ; 91
	%struct.TypeMapModuleEntry {
		i32 33554738, ; uint32_t type_token_id (0x2000132)
		i32 145; uint32_t java_map_index (0x91)
	}, ; 92
	%struct.TypeMapModuleEntry {
		i32 33554739, ; uint32_t type_token_id (0x2000133)
		i32 151; uint32_t java_map_index (0x97)
	}, ; 93
	%struct.TypeMapModuleEntry {
		i32 33554743, ; uint32_t type_token_id (0x2000137)
		i32 162; uint32_t java_map_index (0xa2)
	}, ; 94
	%struct.TypeMapModuleEntry {
		i32 33554745, ; uint32_t type_token_id (0x2000139)
		i32 159; uint32_t java_map_index (0x9f)
	}, ; 95
	%struct.TypeMapModuleEntry {
		i32 33554746, ; uint32_t type_token_id (0x200013a)
		i32 118; uint32_t java_map_index (0x76)
	}, ; 96
	%struct.TypeMapModuleEntry {
		i32 33554749, ; uint32_t type_token_id (0x200013d)
		i32 155; uint32_t java_map_index (0x9b)
	}, ; 97
	%struct.TypeMapModuleEntry {
		i32 33554750, ; uint32_t type_token_id (0x200013e)
		i32 87; uint32_t java_map_index (0x57)
	}, ; 98
	%struct.TypeMapModuleEntry {
		i32 33554752, ; uint32_t type_token_id (0x2000140)
		i32 83; uint32_t java_map_index (0x53)
	}, ; 99
	%struct.TypeMapModuleEntry {
		i32 33554753, ; uint32_t type_token_id (0x2000141)
		i32 9; uint32_t java_map_index (0x9)
	}, ; 100
	%struct.TypeMapModuleEntry {
		i32 33554755, ; uint32_t type_token_id (0x2000143)
		i32 103; uint32_t java_map_index (0x67)
	}, ; 101
	%struct.TypeMapModuleEntry {
		i32 33554757, ; uint32_t type_token_id (0x2000145)
		i32 134; uint32_t java_map_index (0x86)
	}, ; 102
	%struct.TypeMapModuleEntry {
		i32 33554761, ; uint32_t type_token_id (0x2000149)
		i32 148; uint32_t java_map_index (0x94)
	}, ; 103
	%struct.TypeMapModuleEntry {
		i32 33554763, ; uint32_t type_token_id (0x200014b)
		i32 40; uint32_t java_map_index (0x28)
	}, ; 104
	%struct.TypeMapModuleEntry {
		i32 33554766, ; uint32_t type_token_id (0x200014e)
		i32 45; uint32_t java_map_index (0x2d)
	}, ; 105
	%struct.TypeMapModuleEntry {
		i32 33554768, ; uint32_t type_token_id (0x2000150)
		i32 14; uint32_t java_map_index (0xe)
	}, ; 106
	%struct.TypeMapModuleEntry {
		i32 33554770, ; uint32_t type_token_id (0x2000152)
		i32 75; uint32_t java_map_index (0x4b)
	}, ; 107
	%struct.TypeMapModuleEntry {
		i32 33554771, ; uint32_t type_token_id (0x2000153)
		i32 42; uint32_t java_map_index (0x2a)
	}, ; 108
	%struct.TypeMapModuleEntry {
		i32 33554773, ; uint32_t type_token_id (0x2000155)
		i32 66; uint32_t java_map_index (0x42)
	}, ; 109
	%struct.TypeMapModuleEntry {
		i32 33554775, ; uint32_t type_token_id (0x2000157)
		i32 154; uint32_t java_map_index (0x9a)
	}, ; 110
	%struct.TypeMapModuleEntry {
		i32 33554776, ; uint32_t type_token_id (0x2000158)
		i32 90; uint32_t java_map_index (0x5a)
	}, ; 111
	%struct.TypeMapModuleEntry {
		i32 33554777, ; uint32_t type_token_id (0x2000159)
		i32 1; uint32_t java_map_index (0x1)
	}, ; 112
	%struct.TypeMapModuleEntry {
		i32 33554779, ; uint32_t type_token_id (0x200015b)
		i32 21; uint32_t java_map_index (0x15)
	}, ; 113
	%struct.TypeMapModuleEntry {
		i32 33554781, ; uint32_t type_token_id (0x200015d)
		i32 61; uint32_t java_map_index (0x3d)
	}, ; 114
	%struct.TypeMapModuleEntry {
		i32 33554783, ; uint32_t type_token_id (0x200015f)
		i32 15; uint32_t java_map_index (0xf)
	}, ; 115
	%struct.TypeMapModuleEntry {
		i32 33554784, ; uint32_t type_token_id (0x2000160)
		i32 55; uint32_t java_map_index (0x37)
	}, ; 116
	%struct.TypeMapModuleEntry {
		i32 33554786, ; uint32_t type_token_id (0x2000162)
		i32 138; uint32_t java_map_index (0x8a)
	}, ; 117
	%struct.TypeMapModuleEntry {
		i32 33554787, ; uint32_t type_token_id (0x2000163)
		i32 143; uint32_t java_map_index (0x8f)
	}, ; 118
	%struct.TypeMapModuleEntry {
		i32 33554788, ; uint32_t type_token_id (0x2000164)
		i32 130; uint32_t java_map_index (0x82)
	}, ; 119
	%struct.TypeMapModuleEntry {
		i32 33554789, ; uint32_t type_token_id (0x2000165)
		i32 93; uint32_t java_map_index (0x5d)
	}, ; 120
	%struct.TypeMapModuleEntry {
		i32 33554790, ; uint32_t type_token_id (0x2000166)
		i32 38; uint32_t java_map_index (0x26)
	}, ; 121
	%struct.TypeMapModuleEntry {
		i32 33554792, ; uint32_t type_token_id (0x2000168)
		i32 99; uint32_t java_map_index (0x63)
	}, ; 122
	%struct.TypeMapModuleEntry {
		i32 33554793, ; uint32_t type_token_id (0x2000169)
		i32 48; uint32_t java_map_index (0x30)
	}, ; 123
	%struct.TypeMapModuleEntry {
		i32 33554794, ; uint32_t type_token_id (0x200016a)
		i32 92; uint32_t java_map_index (0x5c)
	}, ; 124
	%struct.TypeMapModuleEntry {
		i32 33554795, ; uint32_t type_token_id (0x200016b)
		i32 25; uint32_t java_map_index (0x19)
	}, ; 125
	%struct.TypeMapModuleEntry {
		i32 33554796, ; uint32_t type_token_id (0x200016c)
		i32 135; uint32_t java_map_index (0x87)
	}, ; 126
	%struct.TypeMapModuleEntry {
		i32 33554799, ; uint32_t type_token_id (0x200016f)
		i32 36; uint32_t java_map_index (0x24)
	}, ; 127
	%struct.TypeMapModuleEntry {
		i32 33554800, ; uint32_t type_token_id (0x2000170)
		i32 104; uint32_t java_map_index (0x68)
	}, ; 128
	%struct.TypeMapModuleEntry {
		i32 33554801, ; uint32_t type_token_id (0x2000171)
		i32 152; uint32_t java_map_index (0x98)
	}, ; 129
	%struct.TypeMapModuleEntry {
		i32 33554803, ; uint32_t type_token_id (0x2000173)
		i32 107; uint32_t java_map_index (0x6b)
	}, ; 130
	%struct.TypeMapModuleEntry {
		i32 33554804, ; uint32_t type_token_id (0x2000174)
		i32 169; uint32_t java_map_index (0xa9)
	}, ; 131
	%struct.TypeMapModuleEntry {
		i32 33554805, ; uint32_t type_token_id (0x2000175)
		i32 80; uint32_t java_map_index (0x50)
	}, ; 132
	%struct.TypeMapModuleEntry {
		i32 33554807, ; uint32_t type_token_id (0x2000177)
		i32 29; uint32_t java_map_index (0x1d)
	}, ; 133
	%struct.TypeMapModuleEntry {
		i32 33554808, ; uint32_t type_token_id (0x2000178)
		i32 164; uint32_t java_map_index (0xa4)
	}, ; 134
	%struct.TypeMapModuleEntry {
		i32 33554810, ; uint32_t type_token_id (0x200017a)
		i32 125; uint32_t java_map_index (0x7d)
	}, ; 135
	%struct.TypeMapModuleEntry {
		i32 33554811, ; uint32_t type_token_id (0x200017b)
		i32 166; uint32_t java_map_index (0xa6)
	}, ; 136
	%struct.TypeMapModuleEntry {
		i32 33554813, ; uint32_t type_token_id (0x200017d)
		i32 82; uint32_t java_map_index (0x52)
	}, ; 137
	%struct.TypeMapModuleEntry {
		i32 33554814, ; uint32_t type_token_id (0x200017e)
		i32 71; uint32_t java_map_index (0x47)
	}, ; 138
	%struct.TypeMapModuleEntry {
		i32 33554815, ; uint32_t type_token_id (0x200017f)
		i32 72; uint32_t java_map_index (0x48)
	}, ; 139
	%struct.TypeMapModuleEntry {
		i32 33554816, ; uint32_t type_token_id (0x2000180)
		i32 149; uint32_t java_map_index (0x95)
	}, ; 140
	%struct.TypeMapModuleEntry {
		i32 33554817, ; uint32_t type_token_id (0x2000181)
		i32 52; uint32_t java_map_index (0x34)
	}, ; 141
	%struct.TypeMapModuleEntry {
		i32 33554818, ; uint32_t type_token_id (0x2000182)
		i32 140; uint32_t java_map_index (0x8c)
	}, ; 142
	%struct.TypeMapModuleEntry {
		i32 33554819, ; uint32_t type_token_id (0x2000183)
		i32 95; uint32_t java_map_index (0x5f)
	}, ; 143
	%struct.TypeMapModuleEntry {
		i32 33554821, ; uint32_t type_token_id (0x2000185)
		i32 160; uint32_t java_map_index (0xa0)
	}, ; 144
	%struct.TypeMapModuleEntry {
		i32 33554822, ; uint32_t type_token_id (0x2000186)
		i32 121; uint32_t java_map_index (0x79)
	}, ; 145
	%struct.TypeMapModuleEntry {
		i32 33554823, ; uint32_t type_token_id (0x2000187)
		i32 114; uint32_t java_map_index (0x72)
	}, ; 146
	%struct.TypeMapModuleEntry {
		i32 33554824, ; uint32_t type_token_id (0x2000188)
		i32 28; uint32_t java_map_index (0x1c)
	}, ; 147
	%struct.TypeMapModuleEntry {
		i32 33554827, ; uint32_t type_token_id (0x200018b)
		i32 6; uint32_t java_map_index (0x6)
	}, ; 148
	%struct.TypeMapModuleEntry {
		i32 33554828, ; uint32_t type_token_id (0x200018c)
		i32 22; uint32_t java_map_index (0x16)
	}, ; 149
	%struct.TypeMapModuleEntry {
		i32 33554829, ; uint32_t type_token_id (0x200018d)
		i32 69; uint32_t java_map_index (0x45)
	}, ; 150
	%struct.TypeMapModuleEntry {
		i32 33554830, ; uint32_t type_token_id (0x200018e)
		i32 30; uint32_t java_map_index (0x1e)
	}, ; 151
	%struct.TypeMapModuleEntry {
		i32 33554831, ; uint32_t type_token_id (0x200018f)
		i32 78; uint32_t java_map_index (0x4e)
	}, ; 152
	%struct.TypeMapModuleEntry {
		i32 33554833, ; uint32_t type_token_id (0x2000191)
		i32 13; uint32_t java_map_index (0xd)
	}, ; 153
	%struct.TypeMapModuleEntry {
		i32 33554834, ; uint32_t type_token_id (0x2000192)
		i32 33; uint32_t java_map_index (0x21)
	}, ; 154
	%struct.TypeMapModuleEntry {
		i32 33554835, ; uint32_t type_token_id (0x2000193)
		i32 133; uint32_t java_map_index (0x85)
	}, ; 155
	%struct.TypeMapModuleEntry {
		i32 33554837, ; uint32_t type_token_id (0x2000195)
		i32 0; uint32_t java_map_index (0x0)
	}, ; 156
	%struct.TypeMapModuleEntry {
		i32 33554838, ; uint32_t type_token_id (0x2000196)
		i32 68; uint32_t java_map_index (0x44)
	}, ; 157
	%struct.TypeMapModuleEntry {
		i32 33554839, ; uint32_t type_token_id (0x2000197)
		i32 54; uint32_t java_map_index (0x36)
	}, ; 158
	%struct.TypeMapModuleEntry {
		i32 33554840, ; uint32_t type_token_id (0x2000198)
		i32 35; uint32_t java_map_index (0x23)
	}, ; 159
	%struct.TypeMapModuleEntry {
		i32 33554841, ; uint32_t type_token_id (0x2000199)
		i32 117; uint32_t java_map_index (0x75)
	}, ; 160
	%struct.TypeMapModuleEntry {
		i32 33554842, ; uint32_t type_token_id (0x200019a)
		i32 137; uint32_t java_map_index (0x89)
	}, ; 161
	%struct.TypeMapModuleEntry {
		i32 33554844, ; uint32_t type_token_id (0x200019c)
		i32 32; uint32_t java_map_index (0x20)
	}, ; 162
	%struct.TypeMapModuleEntry {
		i32 33554845, ; uint32_t type_token_id (0x200019d)
		i32 12; uint32_t java_map_index (0xc)
	}, ; 163
	%struct.TypeMapModuleEntry {
		i32 33554846, ; uint32_t type_token_id (0x200019e)
		i32 49; uint32_t java_map_index (0x31)
	}, ; 164
	%struct.TypeMapModuleEntry {
		i32 33554847, ; uint32_t type_token_id (0x200019f)
		i32 97; uint32_t java_map_index (0x61)
	}, ; 165
	%struct.TypeMapModuleEntry {
		i32 33554863, ; uint32_t type_token_id (0x20001af)
		i32 123; uint32_t java_map_index (0x7b)
	} ; 166
], align 4

@module1_managed_to_java_duplicates = internal dso_local constant [63 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554534, ; uint32_t type_token_id (0x2000066)
		i32 91; uint32_t java_map_index (0x5b)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554538, ; uint32_t type_token_id (0x200006a)
		i32 47; uint32_t java_map_index (0x2f)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554540, ; uint32_t type_token_id (0x200006c)
		i32 8; uint32_t java_map_index (0x8)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554543, ; uint32_t type_token_id (0x200006f)
		i32 142; uint32_t java_map_index (0x8e)
	}, ; 3
	%struct.TypeMapModuleEntry {
		i32 33554545, ; uint32_t type_token_id (0x2000071)
		i32 132; uint32_t java_map_index (0x84)
	}, ; 4
	%struct.TypeMapModuleEntry {
		i32 33554547, ; uint32_t type_token_id (0x2000073)
		i32 108; uint32_t java_map_index (0x6c)
	}, ; 5
	%struct.TypeMapModuleEntry {
		i32 33554549, ; uint32_t type_token_id (0x2000075)
		i32 53; uint32_t java_map_index (0x35)
	}, ; 6
	%struct.TypeMapModuleEntry {
		i32 33554551, ; uint32_t type_token_id (0x2000077)
		i32 129; uint32_t java_map_index (0x81)
	}, ; 7
	%struct.TypeMapModuleEntry {
		i32 33554553, ; uint32_t type_token_id (0x2000079)
		i32 4; uint32_t java_map_index (0x4)
	}, ; 8
	%struct.TypeMapModuleEntry {
		i32 33554555, ; uint32_t type_token_id (0x200007b)
		i32 34; uint32_t java_map_index (0x22)
	}, ; 9
	%struct.TypeMapModuleEntry {
		i32 33554559, ; uint32_t type_token_id (0x200007f)
		i32 158; uint32_t java_map_index (0x9e)
	}, ; 10
	%struct.TypeMapModuleEntry {
		i32 33554563, ; uint32_t type_token_id (0x2000083)
		i32 17; uint32_t java_map_index (0x11)
	}, ; 11
	%struct.TypeMapModuleEntry {
		i32 33554565, ; uint32_t type_token_id (0x2000085)
		i32 86; uint32_t java_map_index (0x56)
	}, ; 12
	%struct.TypeMapModuleEntry {
		i32 33554568, ; uint32_t type_token_id (0x2000088)
		i32 106; uint32_t java_map_index (0x6a)
	}, ; 13
	%struct.TypeMapModuleEntry {
		i32 33554574, ; uint32_t type_token_id (0x200008e)
		i32 110; uint32_t java_map_index (0x6e)
	}, ; 14
	%struct.TypeMapModuleEntry {
		i32 33554576, ; uint32_t type_token_id (0x2000090)
		i32 88; uint32_t java_map_index (0x58)
	}, ; 15
	%struct.TypeMapModuleEntry {
		i32 33554584, ; uint32_t type_token_id (0x2000098)
		i32 44; uint32_t java_map_index (0x2c)
	}, ; 16
	%struct.TypeMapModuleEntry {
		i32 33554591, ; uint32_t type_token_id (0x200009f)
		i32 86; uint32_t java_map_index (0x56)
	}, ; 17
	%struct.TypeMapModuleEntry {
		i32 33554592, ; uint32_t type_token_id (0x20000a0)
		i32 131; uint32_t java_map_index (0x83)
	}, ; 18
	%struct.TypeMapModuleEntry {
		i32 33554594, ; uint32_t type_token_id (0x20000a2)
		i32 65; uint32_t java_map_index (0x41)
	}, ; 19
	%struct.TypeMapModuleEntry {
		i32 33554596, ; uint32_t type_token_id (0x20000a4)
		i32 153; uint32_t java_map_index (0x99)
	}, ; 20
	%struct.TypeMapModuleEntry {
		i32 33554598, ; uint32_t type_token_id (0x20000a6)
		i32 113; uint32_t java_map_index (0x71)
	}, ; 21
	%struct.TypeMapModuleEntry {
		i32 33554603, ; uint32_t type_token_id (0x20000ab)
		i32 101; uint32_t java_map_index (0x65)
	}, ; 22
	%struct.TypeMapModuleEntry {
		i32 33554608, ; uint32_t type_token_id (0x20000b0)
		i32 120; uint32_t java_map_index (0x78)
	}, ; 23
	%struct.TypeMapModuleEntry {
		i32 33554616, ; uint32_t type_token_id (0x20000b8)
		i32 31; uint32_t java_map_index (0x1f)
	}, ; 24
	%struct.TypeMapModuleEntry {
		i32 33554618, ; uint32_t type_token_id (0x20000ba)
		i32 126; uint32_t java_map_index (0x7e)
	}, ; 25
	%struct.TypeMapModuleEntry {
		i32 33554620, ; uint32_t type_token_id (0x20000bc)
		i32 74; uint32_t java_map_index (0x4a)
	}, ; 26
	%struct.TypeMapModuleEntry {
		i32 33554626, ; uint32_t type_token_id (0x20000c2)
		i32 147; uint32_t java_map_index (0x93)
	}, ; 27
	%struct.TypeMapModuleEntry {
		i32 33554628, ; uint32_t type_token_id (0x20000c4)
		i32 39; uint32_t java_map_index (0x27)
	}, ; 28
	%struct.TypeMapModuleEntry {
		i32 33554647, ; uint32_t type_token_id (0x20000d7)
		i32 119; uint32_t java_map_index (0x77)
	}, ; 29
	%struct.TypeMapModuleEntry {
		i32 33554652, ; uint32_t type_token_id (0x20000dc)
		i32 77; uint32_t java_map_index (0x4d)
	}, ; 30
	%struct.TypeMapModuleEntry {
		i32 33554655, ; uint32_t type_token_id (0x20000df)
		i32 70; uint32_t java_map_index (0x46)
	}, ; 31
	%struct.TypeMapModuleEntry {
		i32 33554666, ; uint32_t type_token_id (0x20000ea)
		i32 2; uint32_t java_map_index (0x2)
	}, ; 32
	%struct.TypeMapModuleEntry {
		i32 33554668, ; uint32_t type_token_id (0x20000ec)
		i32 146; uint32_t java_map_index (0x92)
	}, ; 33
	%struct.TypeMapModuleEntry {
		i32 33554700, ; uint32_t type_token_id (0x200010c)
		i32 51; uint32_t java_map_index (0x33)
	}, ; 34
	%struct.TypeMapModuleEntry {
		i32 33554706, ; uint32_t type_token_id (0x2000112)
		i32 59; uint32_t java_map_index (0x3b)
	}, ; 35
	%struct.TypeMapModuleEntry {
		i32 33554711, ; uint32_t type_token_id (0x2000117)
		i32 27; uint32_t java_map_index (0x1b)
	}, ; 36
	%struct.TypeMapModuleEntry {
		i32 33554715, ; uint32_t type_token_id (0x200011b)
		i32 170; uint32_t java_map_index (0xaa)
	}, ; 37
	%struct.TypeMapModuleEntry {
		i32 33554744, ; uint32_t type_token_id (0x2000138)
		i32 162; uint32_t java_map_index (0xa2)
	}, ; 38
	%struct.TypeMapModuleEntry {
		i32 33554747, ; uint32_t type_token_id (0x200013b)
		i32 118; uint32_t java_map_index (0x76)
	}, ; 39
	%struct.TypeMapModuleEntry {
		i32 33554751, ; uint32_t type_token_id (0x200013f)
		i32 87; uint32_t java_map_index (0x57)
	}, ; 40
	%struct.TypeMapModuleEntry {
		i32 33554754, ; uint32_t type_token_id (0x2000142)
		i32 9; uint32_t java_map_index (0x9)
	}, ; 41
	%struct.TypeMapModuleEntry {
		i32 33554756, ; uint32_t type_token_id (0x2000144)
		i32 103; uint32_t java_map_index (0x67)
	}, ; 42
	%struct.TypeMapModuleEntry {
		i32 33554758, ; uint32_t type_token_id (0x2000146)
		i32 134; uint32_t java_map_index (0x86)
	}, ; 43
	%struct.TypeMapModuleEntry {
		i32 33554762, ; uint32_t type_token_id (0x200014a)
		i32 148; uint32_t java_map_index (0x94)
	}, ; 44
	%struct.TypeMapModuleEntry {
		i32 33554767, ; uint32_t type_token_id (0x200014f)
		i32 45; uint32_t java_map_index (0x2d)
	}, ; 45
	%struct.TypeMapModuleEntry {
		i32 33554769, ; uint32_t type_token_id (0x2000151)
		i32 14; uint32_t java_map_index (0xe)
	}, ; 46
	%struct.TypeMapModuleEntry {
		i32 33554772, ; uint32_t type_token_id (0x2000154)
		i32 42; uint32_t java_map_index (0x2a)
	}, ; 47
	%struct.TypeMapModuleEntry {
		i32 33554774, ; uint32_t type_token_id (0x2000156)
		i32 66; uint32_t java_map_index (0x42)
	}, ; 48
	%struct.TypeMapModuleEntry {
		i32 33554778, ; uint32_t type_token_id (0x200015a)
		i32 1; uint32_t java_map_index (0x1)
	}, ; 49
	%struct.TypeMapModuleEntry {
		i32 33554780, ; uint32_t type_token_id (0x200015c)
		i32 21; uint32_t java_map_index (0x15)
	}, ; 50
	%struct.TypeMapModuleEntry {
		i32 33554782, ; uint32_t type_token_id (0x200015e)
		i32 61; uint32_t java_map_index (0x3d)
	}, ; 51
	%struct.TypeMapModuleEntry {
		i32 33554785, ; uint32_t type_token_id (0x2000161)
		i32 55; uint32_t java_map_index (0x37)
	}, ; 52
	%struct.TypeMapModuleEntry {
		i32 33554791, ; uint32_t type_token_id (0x2000167)
		i32 38; uint32_t java_map_index (0x26)
	}, ; 53
	%struct.TypeMapModuleEntry {
		i32 33554797, ; uint32_t type_token_id (0x200016d)
		i32 135; uint32_t java_map_index (0x87)
	}, ; 54
	%struct.TypeMapModuleEntry {
		i32 33554802, ; uint32_t type_token_id (0x2000172)
		i32 152; uint32_t java_map_index (0x98)
	}, ; 55
	%struct.TypeMapModuleEntry {
		i32 33554806, ; uint32_t type_token_id (0x2000176)
		i32 80; uint32_t java_map_index (0x50)
	}, ; 56
	%struct.TypeMapModuleEntry {
		i32 33554809, ; uint32_t type_token_id (0x2000179)
		i32 164; uint32_t java_map_index (0xa4)
	}, ; 57
	%struct.TypeMapModuleEntry {
		i32 33554812, ; uint32_t type_token_id (0x200017c)
		i32 166; uint32_t java_map_index (0xa6)
	}, ; 58
	%struct.TypeMapModuleEntry {
		i32 33554820, ; uint32_t type_token_id (0x2000184)
		i32 95; uint32_t java_map_index (0x5f)
	}, ; 59
	%struct.TypeMapModuleEntry {
		i32 33554825, ; uint32_t type_token_id (0x2000189)
		i32 28; uint32_t java_map_index (0x1c)
	}, ; 60
	%struct.TypeMapModuleEntry {
		i32 33554832, ; uint32_t type_token_id (0x2000190)
		i32 78; uint32_t java_map_index (0x4e)
	}, ; 61
	%struct.TypeMapModuleEntry {
		i32 33554836, ; uint32_t type_token_id (0x2000194)
		i32 133; uint32_t java_map_index (0x85)
	} ; 62
], align 4

; Java to managed map
@map_java = dso_local local_unnamed_addr constant [171 x %struct.TypeMapJava] [
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554837, ; uint32_t type_token_id (0x2000195)
		i32 160; uint32_t java_name_index (0xa0)
	}, ; 0
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554777, ; uint32_t type_token_id (0x2000159)
		i32 116; uint32_t java_name_index (0x74)
	}, ; 1
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554663, ; uint32_t type_token_id (0x20000e7)
		i32 80; uint32_t java_name_index (0x50)
	}, ; 2
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554606, ; uint32_t type_token_id (0x20000ae)
		i32 47; uint32_t java_name_index (0x2f)
	}, ; 3
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 14; uint32_t java_name_index (0xe)
	}, ; 4
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554648, ; uint32_t type_token_id (0x20000d8)
		i32 73; uint32_t java_name_index (0x49)
	}, ; 5
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554827, ; uint32_t type_token_id (0x200018b)
		i32 152; uint32_t java_name_index (0x98)
	}, ; 6
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554439, ; uint32_t type_token_id (0x2000007)
		i32 3; uint32_t java_name_index (0x3)
	}, ; 7
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554539, ; uint32_t type_token_id (0x200006b)
		i32 7; uint32_t java_name_index (0x7)
	}, ; 8
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 104; uint32_t java_name_index (0x68)
	}, ; 9
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554438, ; uint32_t type_token_id (0x2000006)
		i32 2; uint32_t java_name_index (0x2)
	}, ; 10
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554664, ; uint32_t type_token_id (0x20000e8)
		i32 81; uint32_t java_name_index (0x51)
	}, ; 11
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554845, ; uint32_t type_token_id (0x200019d)
		i32 167; uint32_t java_name_index (0xa7)
	}, ; 12
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554833, ; uint32_t type_token_id (0x2000191)
		i32 157; uint32_t java_name_index (0x9d)
	}, ; 13
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 110; uint32_t java_name_index (0x6e)
	}, ; 14
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554783, ; uint32_t type_token_id (0x200015f)
		i32 119; uint32_t java_name_index (0x77)
	}, ; 15
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554737, ; uint32_t type_token_id (0x2000131)
		i32 95; uint32_t java_name_index (0x5f)
	}, ; 16
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554562, ; uint32_t type_token_id (0x2000082)
		i32 21; uint32_t java_name_index (0x15)
	}, ; 17
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554665, ; uint32_t type_token_id (0x20000e9)
		i32 82; uint32_t java_name_index (0x52)
	}, ; 18
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554622, ; uint32_t type_token_id (0x20000be)
		i32 58; uint32_t java_name_index (0x3a)
	}, ; 19
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554727, ; uint32_t type_token_id (0x2000127)
		i32 93; uint32_t java_name_index (0x5d)
	}, ; 20
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554779, ; uint32_t type_token_id (0x200015b)
		i32 117; uint32_t java_name_index (0x75)
	}, ; 21
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554828, ; uint32_t type_token_id (0x200018c)
		i32 153; uint32_t java_name_index (0x99)
	}, ; 22
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554613, ; uint32_t type_token_id (0x20000b5)
		i32 52; uint32_t java_name_index (0x34)
	}, ; 23
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554635, ; uint32_t type_token_id (0x20000cb)
		i32 66; uint32_t java_name_index (0x42)
	}, ; 24
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554795, ; uint32_t type_token_id (0x200016b)
		i32 129; uint32_t java_name_index (0x81)
	}, ; 25
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554437, ; uint32_t type_token_id (0x2000005)
		i32 1; uint32_t java_name_index (0x1)
	}, ; 26
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554710, ; uint32_t type_token_id (0x2000116)
		i32 89; uint32_t java_name_index (0x59)
	}, ; 27
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 151; uint32_t java_name_index (0x97)
	}, ; 28
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554807, ; uint32_t type_token_id (0x2000177)
		i32 137; uint32_t java_name_index (0x89)
	}, ; 29
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554830, ; uint32_t type_token_id (0x200018e)
		i32 155; uint32_t java_name_index (0x9b)
	}, ; 30
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 54; uint32_t java_name_index (0x36)
	}, ; 31
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554844, ; uint32_t type_token_id (0x200019c)
		i32 166; uint32_t java_name_index (0xa6)
	}, ; 32
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554834, ; uint32_t type_token_id (0x2000192)
		i32 158; uint32_t java_name_index (0x9e)
	}, ; 33
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 15; uint32_t java_name_index (0xf)
	}, ; 34
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554840, ; uint32_t type_token_id (0x2000198)
		i32 163; uint32_t java_name_index (0xa3)
	}, ; 35
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554799, ; uint32_t type_token_id (0x200016f)
		i32 131; uint32_t java_name_index (0x83)
	}, ; 36
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554570, ; uint32_t type_token_id (0x200008a)
		i32 26; uint32_t java_name_index (0x1a)
	}, ; 37
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554790, ; uint32_t type_token_id (0x2000166)
		i32 125; uint32_t java_name_index (0x7d)
	}, ; 38
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554627, ; uint32_t type_token_id (0x20000c3)
		i32 60; uint32_t java_name_index (0x3c)
	}, ; 39
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554763, ; uint32_t type_token_id (0x200014b)
		i32 108; uint32_t java_name_index (0x6c)
	}, ; 40
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554561, ; uint32_t type_token_id (0x2000081)
		i32 20; uint32_t java_name_index (0x14)
	}, ; 41
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 112; uint32_t java_name_index (0x70)
	}, ; 42
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554556, ; uint32_t type_token_id (0x200007c)
		i32 16; uint32_t java_name_index (0x10)
	}, ; 43
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 37; uint32_t java_name_index (0x25)
	}, ; 44
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 109; uint32_t java_name_index (0x6d)
	}, ; 45
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554637, ; uint32_t type_token_id (0x20000cd)
		i32 68; uint32_t java_name_index (0x44)
	}, ; 46
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554537, ; uint32_t type_token_id (0x2000069)
		i32 6; uint32_t java_name_index (0x6)
	}, ; 47
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554793, ; uint32_t type_token_id (0x2000169)
		i32 127; uint32_t java_name_index (0x7f)
	}, ; 48
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554846, ; uint32_t type_token_id (0x200019e)
		i32 168; uint32_t java_name_index (0xa8)
	}, ; 49
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554557, ; uint32_t type_token_id (0x200007d)
		i32 17; uint32_t java_name_index (0x11)
	}, ; 50
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554699, ; uint32_t type_token_id (0x200010b)
		i32 87; uint32_t java_name_index (0x57)
	}, ; 51
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554817, ; uint32_t type_token_id (0x2000181)
		i32 145; uint32_t java_name_index (0x91)
	}, ; 52
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 12; uint32_t java_name_index (0xc)
	}, ; 53
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554839, ; uint32_t type_token_id (0x2000197)
		i32 162; uint32_t java_name_index (0xa2)
	}, ; 54
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554784, ; uint32_t type_token_id (0x2000160)
		i32 120; uint32_t java_name_index (0x78)
	}, ; 55
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554578, ; uint32_t type_token_id (0x2000092)
		i32 32; uint32_t java_name_index (0x20)
	}, ; 56
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554579, ; uint32_t type_token_id (0x2000093)
		i32 33; uint32_t java_name_index (0x21)
	}, ; 57
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554636, ; uint32_t type_token_id (0x20000cc)
		i32 67; uint32_t java_name_index (0x43)
	}, ; 58
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554701, ; uint32_t type_token_id (0x200010d)
		i32 88; uint32_t java_name_index (0x58)
	}, ; 59
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554541, ; uint32_t type_token_id (0x200006d)
		i32 8; uint32_t java_name_index (0x8)
	}, ; 60
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554781, ; uint32_t type_token_id (0x200015d)
		i32 118; uint32_t java_name_index (0x76)
	}, ; 61
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554569, ; uint32_t type_token_id (0x2000089)
		i32 25; uint32_t java_name_index (0x19)
	}, ; 62
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554631, ; uint32_t type_token_id (0x20000c7)
		i32 62; uint32_t java_name_index (0x3e)
	}, ; 63
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554614, ; uint32_t type_token_id (0x20000b6)
		i32 53; uint32_t java_name_index (0x35)
	}, ; 64
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554593, ; uint32_t type_token_id (0x20000a1)
		i32 39; uint32_t java_name_index (0x27)
	}, ; 65
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 113; uint32_t java_name_index (0x71)
	}, ; 66
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554650, ; uint32_t type_token_id (0x20000da)
		i32 75; uint32_t java_name_index (0x4b)
	}, ; 67
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554838, ; uint32_t type_token_id (0x2000196)
		i32 161; uint32_t java_name_index (0xa1)
	}, ; 68
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554829, ; uint32_t type_token_id (0x200018d)
		i32 154; uint32_t java_name_index (0x9a)
	}, ; 69
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 78; uint32_t java_name_index (0x4e)
	}, ; 70
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554814, ; uint32_t type_token_id (0x200017e)
		i32 142; uint32_t java_name_index (0x8e)
	}, ; 71
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554815, ; uint32_t type_token_id (0x200017f)
		i32 143; uint32_t java_name_index (0x8f)
	}, ; 72
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554571, ; uint32_t type_token_id (0x200008b)
		i32 27; uint32_t java_name_index (0x1b)
	}, ; 73
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 56; uint32_t java_name_index (0x38)
	}, ; 74
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554770, ; uint32_t type_token_id (0x2000152)
		i32 111; uint32_t java_name_index (0x6f)
	}, ; 75
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554610, ; uint32_t type_token_id (0x20000b2)
		i32 49; uint32_t java_name_index (0x31)
	}, ; 76
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 76; uint32_t java_name_index (0x4c)
	}, ; 77
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 156; uint32_t java_name_index (0x9c)
	}, ; 78
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554577, ; uint32_t type_token_id (0x2000091)
		i32 31; uint32_t java_name_index (0x1f)
	}, ; 79
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554805, ; uint32_t type_token_id (0x2000175)
		i32 136; uint32_t java_name_index (0x88)
	}, ; 80
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554630, ; uint32_t type_token_id (0x20000c6)
		i32 61; uint32_t java_name_index (0x3d)
	}, ; 81
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554813, ; uint32_t type_token_id (0x200017d)
		i32 141; uint32_t java_name_index (0x8d)
	}, ; 82
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554752, ; uint32_t type_token_id (0x2000140)
		i32 103; uint32_t java_name_index (0x67)
	}, ; 83
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554572, ; uint32_t type_token_id (0x200008c)
		i32 28; uint32_t java_name_index (0x1c)
	}, ; 84
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554645, ; uint32_t type_token_id (0x20000d5)
		i32 71; uint32_t java_name_index (0x47)
	}, ; 85
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554564, ; uint32_t type_token_id (0x2000084)
		i32 22; uint32_t java_name_index (0x16)
	}, ; 86
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 102; uint32_t java_name_index (0x66)
	}, ; 87
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 30; uint32_t java_name_index (0x1e)
	}, ; 88
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554632, ; uint32_t type_token_id (0x20000c8)
		i32 63; uint32_t java_name_index (0x3f)
	}, ; 89
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554776, ; uint32_t type_token_id (0x2000158)
		i32 115; uint32_t java_name_index (0x73)
	}, ; 90
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 4; uint32_t java_name_index (0x4)
	}, ; 91
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554794, ; uint32_t type_token_id (0x200016a)
		i32 128; uint32_t java_name_index (0x80)
	}, ; 92
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554789, ; uint32_t type_token_id (0x2000165)
		i32 124; uint32_t java_name_index (0x7c)
	}, ; 93
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554633, ; uint32_t type_token_id (0x20000c9)
		i32 64; uint32_t java_name_index (0x40)
	}, ; 94
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554819, ; uint32_t type_token_id (0x2000183)
		i32 147; uint32_t java_name_index (0x93)
	}, ; 95
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554639, ; uint32_t type_token_id (0x20000cf)
		i32 70; uint32_t java_name_index (0x46)
	}, ; 96
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554847, ; uint32_t type_token_id (0x200019f)
		i32 169; uint32_t java_name_index (0xa9)
	}, ; 97
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554586, ; uint32_t type_token_id (0x200009a)
		i32 38; uint32_t java_name_index (0x26)
	}, ; 98
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554792, ; uint32_t type_token_id (0x2000168)
		i32 126; uint32_t java_name_index (0x7e)
	}, ; 99
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554535, ; uint32_t type_token_id (0x2000067)
		i32 5; uint32_t java_name_index (0x5)
	}, ; 100
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554602, ; uint32_t type_token_id (0x20000aa)
		i32 44; uint32_t java_name_index (0x2c)
	}, ; 101
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554638, ; uint32_t type_token_id (0x20000ce)
		i32 69; uint32_t java_name_index (0x45)
	}, ; 102
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 105; uint32_t java_name_index (0x69)
	}, ; 103
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554800, ; uint32_t type_token_id (0x2000170)
		i32 132; uint32_t java_name_index (0x84)
	}, ; 104
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554736, ; uint32_t type_token_id (0x2000130)
		i32 94; uint32_t java_name_index (0x5e)
	}, ; 105
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554567, ; uint32_t type_token_id (0x2000087)
		i32 24; uint32_t java_name_index (0x18)
	}, ; 106
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554803, ; uint32_t type_token_id (0x2000173)
		i32 134; uint32_t java_name_index (0x86)
	}, ; 107
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 11; uint32_t java_name_index (0xb)
	}, ; 108
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554605, ; uint32_t type_token_id (0x20000ad)
		i32 46; uint32_t java_name_index (0x2e)
	}, ; 109
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 29; uint32_t java_name_index (0x1d)
	}, ; 110
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554649, ; uint32_t type_token_id (0x20000d9)
		i32 74; uint32_t java_name_index (0x4a)
	}, ; 111
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554582, ; uint32_t type_token_id (0x2000096)
		i32 36; uint32_t java_name_index (0x24)
	}, ; 112
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 41; uint32_t java_name_index (0x29)
	}, ; 113
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554823, ; uint32_t type_token_id (0x2000187)
		i32 150; uint32_t java_name_index (0x96)
	}, ; 114
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554611, ; uint32_t type_token_id (0x20000b3)
		i32 50; uint32_t java_name_index (0x32)
	}, ; 115
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554580, ; uint32_t type_token_id (0x2000094)
		i32 34; uint32_t java_name_index (0x22)
	}, ; 116
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554841, ; uint32_t type_token_id (0x2000199)
		i32 164; uint32_t java_name_index (0xa4)
	}, ; 117
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 100; uint32_t java_name_index (0x64)
	}, ; 118
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554646, ; uint32_t type_token_id (0x20000d6)
		i32 72; uint32_t java_name_index (0x48)
	}, ; 119
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 48; uint32_t java_name_index (0x30)
	}, ; 120
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554822, ; uint32_t type_token_id (0x2000186)
		i32 149; uint32_t java_name_index (0x95)
	}, ; 121
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 86; uint32_t java_name_index (0x56)
	}, ; 122
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554863, ; uint32_t type_token_id (0x20001af)
		i32 170; uint32_t java_name_index (0xaa)
	}, ; 123
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554581, ; uint32_t type_token_id (0x2000095)
		i32 35; uint32_t java_name_index (0x23)
	}, ; 124
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554810, ; uint32_t type_token_id (0x200017a)
		i32 139; uint32_t java_name_index (0x8b)
	}, ; 125
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 55; uint32_t java_name_index (0x37)
	}, ; 126
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554672, ; uint32_t type_token_id (0x20000f0)
		i32 84; uint32_t java_name_index (0x54)
	}, ; 127
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554600, ; uint32_t type_token_id (0x20000a8)
		i32 42; uint32_t java_name_index (0x2a)
	}, ; 128
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 13; uint32_t java_name_index (0xd)
	}, ; 129
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554788, ; uint32_t type_token_id (0x2000164)
		i32 123; uint32_t java_name_index (0x7b)
	}, ; 130
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554566, ; uint32_t type_token_id (0x2000086)
		i32 23; uint32_t java_name_index (0x17)
	}, ; 131
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554544, ; uint32_t type_token_id (0x2000070)
		i32 10; uint32_t java_name_index (0xa)
	}, ; 132
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554835, ; uint32_t type_token_id (0x2000193)
		i32 159; uint32_t java_name_index (0x9f)
	}, ; 133
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 106; uint32_t java_name_index (0x6a)
	}, ; 134
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554796, ; uint32_t type_token_id (0x200016c)
		i32 130; uint32_t java_name_index (0x82)
	}, ; 135
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554713, ; uint32_t type_token_id (0x2000119)
		i32 91; uint32_t java_name_index (0x5b)
	}, ; 136
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554842, ; uint32_t type_token_id (0x200019a)
		i32 165; uint32_t java_name_index (0xa5)
	}, ; 137
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554786, ; uint32_t type_token_id (0x2000162)
		i32 121; uint32_t java_name_index (0x79)
	}, ; 138
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554712, ; uint32_t type_token_id (0x2000118)
		i32 90; uint32_t java_name_index (0x5a)
	}, ; 139
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554818, ; uint32_t type_token_id (0x2000182)
		i32 146; uint32_t java_name_index (0x92)
	}, ; 140
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554612, ; uint32_t type_token_id (0x20000b4)
		i32 51; uint32_t java_name_index (0x33)
	}, ; 141
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554542, ; uint32_t type_token_id (0x200006e)
		i32 9; uint32_t java_name_index (0x9)
	}, ; 142
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554787, ; uint32_t type_token_id (0x2000163)
		i32 122; uint32_t java_name_index (0x7a)
	}, ; 143
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554601, ; uint32_t type_token_id (0x20000a9)
		i32 43; uint32_t java_name_index (0x2b)
	}, ; 144
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554738, ; uint32_t type_token_id (0x2000132)
		i32 96; uint32_t java_name_index (0x60)
	}, ; 145
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554667, ; uint32_t type_token_id (0x20000eb)
		i32 83; uint32_t java_name_index (0x53)
	}, ; 146
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554625, ; uint32_t type_token_id (0x20000c1)
		i32 59; uint32_t java_name_index (0x3b)
	}, ; 147
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 107; uint32_t java_name_index (0x6b)
	}, ; 148
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554816, ; uint32_t type_token_id (0x2000180)
		i32 144; uint32_t java_name_index (0x90)
	}, ; 149
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554604, ; uint32_t type_token_id (0x20000ac)
		i32 45; uint32_t java_name_index (0x2d)
	}, ; 150
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554739, ; uint32_t type_token_id (0x2000133)
		i32 97; uint32_t java_name_index (0x61)
	}, ; 151
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554801, ; uint32_t type_token_id (0x2000171)
		i32 133; uint32_t java_name_index (0x85)
	}, ; 152
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 40; uint32_t java_name_index (0x28)
	}, ; 153
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554775, ; uint32_t type_token_id (0x2000157)
		i32 114; uint32_t java_name_index (0x72)
	}, ; 154
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554749, ; uint32_t type_token_id (0x200013d)
		i32 101; uint32_t java_name_index (0x65)
	}, ; 155
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554695, ; uint32_t type_token_id (0x2000107)
		i32 85; uint32_t java_name_index (0x55)
	}, ; 156
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554435, ; uint32_t type_token_id (0x2000003)
		i32 0; uint32_t java_name_index (0x0)
	}, ; 157
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554558, ; uint32_t type_token_id (0x200007e)
		i32 18; uint32_t java_name_index (0x12)
	}, ; 158
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554745, ; uint32_t type_token_id (0x2000139)
		i32 99; uint32_t java_name_index (0x63)
	}, ; 159
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554821, ; uint32_t type_token_id (0x2000185)
		i32 148; uint32_t java_name_index (0x94)
	}, ; 160
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554634, ; uint32_t type_token_id (0x20000ca)
		i32 65; uint32_t java_name_index (0x41)
	}, ; 161
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554743, ; uint32_t type_token_id (0x2000137)
		i32 98; uint32_t java_name_index (0x62)
	}, ; 162
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554657, ; uint32_t type_token_id (0x20000e1)
		i32 79; uint32_t java_name_index (0x4f)
	}, ; 163
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554808, ; uint32_t type_token_id (0x2000178)
		i32 138; uint32_t java_name_index (0x8a)
	}, ; 164
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554653, ; uint32_t type_token_id (0x20000dd)
		i32 77; uint32_t java_name_index (0x4d)
	}, ; 165
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554811, ; uint32_t type_token_id (0x200017b)
		i32 140; uint32_t java_name_index (0x8c)
	}, ; 166
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554621, ; uint32_t type_token_id (0x20000bd)
		i32 57; uint32_t java_name_index (0x39)
	}, ; 167
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554560, ; uint32_t type_token_id (0x2000080)
		i32 19; uint32_t java_name_index (0x13)
	}, ; 168
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554804, ; uint32_t type_token_id (0x2000174)
		i32 135; uint32_t java_name_index (0x87)
	}, ; 169
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554714, ; uint32_t type_token_id (0x200011a)
		i32 92; uint32_t java_name_index (0x5c)
	} ; 170
], align 4

; Java type names
@java_type_names = dso_local local_unnamed_addr constant [171 x ptr] [
	ptr @.str.0, ; 0
	ptr @.str.1, ; 1
	ptr @.str.2, ; 2
	ptr @.str.3, ; 3
	ptr @.str.4, ; 4
	ptr @.str.5, ; 5
	ptr @.str.6, ; 6
	ptr @.str.7, ; 7
	ptr @.str.8, ; 8
	ptr @.str.9, ; 9
	ptr @.str.10, ; 10
	ptr @.str.11, ; 11
	ptr @.str.12, ; 12
	ptr @.str.13, ; 13
	ptr @.str.14, ; 14
	ptr @.str.15, ; 15
	ptr @.str.16, ; 16
	ptr @.str.17, ; 17
	ptr @.str.18, ; 18
	ptr @.str.19, ; 19
	ptr @.str.20, ; 20
	ptr @.str.21, ; 21
	ptr @.str.22, ; 22
	ptr @.str.23, ; 23
	ptr @.str.24, ; 24
	ptr @.str.25, ; 25
	ptr @.str.26, ; 26
	ptr @.str.27, ; 27
	ptr @.str.28, ; 28
	ptr @.str.29, ; 29
	ptr @.str.30, ; 30
	ptr @.str.31, ; 31
	ptr @.str.32, ; 32
	ptr @.str.33, ; 33
	ptr @.str.34, ; 34
	ptr @.str.35, ; 35
	ptr @.str.36, ; 36
	ptr @.str.37, ; 37
	ptr @.str.38, ; 38
	ptr @.str.39, ; 39
	ptr @.str.40, ; 40
	ptr @.str.41, ; 41
	ptr @.str.42, ; 42
	ptr @.str.43, ; 43
	ptr @.str.44, ; 44
	ptr @.str.45, ; 45
	ptr @.str.46, ; 46
	ptr @.str.47, ; 47
	ptr @.str.48, ; 48
	ptr @.str.49, ; 49
	ptr @.str.50, ; 50
	ptr @.str.51, ; 51
	ptr @.str.52, ; 52
	ptr @.str.53, ; 53
	ptr @.str.54, ; 54
	ptr @.str.55, ; 55
	ptr @.str.56, ; 56
	ptr @.str.57, ; 57
	ptr @.str.58, ; 58
	ptr @.str.59, ; 59
	ptr @.str.60, ; 60
	ptr @.str.61, ; 61
	ptr @.str.62, ; 62
	ptr @.str.63, ; 63
	ptr @.str.64, ; 64
	ptr @.str.65, ; 65
	ptr @.str.66, ; 66
	ptr @.str.67, ; 67
	ptr @.str.68, ; 68
	ptr @.str.69, ; 69
	ptr @.str.70, ; 70
	ptr @.str.71, ; 71
	ptr @.str.72, ; 72
	ptr @.str.73, ; 73
	ptr @.str.74, ; 74
	ptr @.str.75, ; 75
	ptr @.str.76, ; 76
	ptr @.str.77, ; 77
	ptr @.str.78, ; 78
	ptr @.str.79, ; 79
	ptr @.str.80, ; 80
	ptr @.str.81, ; 81
	ptr @.str.82, ; 82
	ptr @.str.83, ; 83
	ptr @.str.84, ; 84
	ptr @.str.85, ; 85
	ptr @.str.86, ; 86
	ptr @.str.87, ; 87
	ptr @.str.88, ; 88
	ptr @.str.89, ; 89
	ptr @.str.90, ; 90
	ptr @.str.91, ; 91
	ptr @.str.92, ; 92
	ptr @.str.93, ; 93
	ptr @.str.94, ; 94
	ptr @.str.95, ; 95
	ptr @.str.96, ; 96
	ptr @.str.97, ; 97
	ptr @.str.98, ; 98
	ptr @.str.99, ; 99
	ptr @.str.100, ; 100
	ptr @.str.101, ; 101
	ptr @.str.102, ; 102
	ptr @.str.103, ; 103
	ptr @.str.104, ; 104
	ptr @.str.105, ; 105
	ptr @.str.106, ; 106
	ptr @.str.107, ; 107
	ptr @.str.108, ; 108
	ptr @.str.109, ; 109
	ptr @.str.110, ; 110
	ptr @.str.111, ; 111
	ptr @.str.112, ; 112
	ptr @.str.113, ; 113
	ptr @.str.114, ; 114
	ptr @.str.115, ; 115
	ptr @.str.116, ; 116
	ptr @.str.117, ; 117
	ptr @.str.118, ; 118
	ptr @.str.119, ; 119
	ptr @.str.120, ; 120
	ptr @.str.121, ; 121
	ptr @.str.122, ; 122
	ptr @.str.123, ; 123
	ptr @.str.124, ; 124
	ptr @.str.125, ; 125
	ptr @.str.126, ; 126
	ptr @.str.127, ; 127
	ptr @.str.128, ; 128
	ptr @.str.129, ; 129
	ptr @.str.130, ; 130
	ptr @.str.131, ; 131
	ptr @.str.132, ; 132
	ptr @.str.133, ; 133
	ptr @.str.134, ; 134
	ptr @.str.135, ; 135
	ptr @.str.136, ; 136
	ptr @.str.137, ; 137
	ptr @.str.138, ; 138
	ptr @.str.139, ; 139
	ptr @.str.140, ; 140
	ptr @.str.141, ; 141
	ptr @.str.142, ; 142
	ptr @.str.143, ; 143
	ptr @.str.144, ; 144
	ptr @.str.145, ; 145
	ptr @.str.146, ; 146
	ptr @.str.147, ; 147
	ptr @.str.148, ; 148
	ptr @.str.149, ; 149
	ptr @.str.150, ; 150
	ptr @.str.151, ; 151
	ptr @.str.152, ; 152
	ptr @.str.153, ; 153
	ptr @.str.154, ; 154
	ptr @.str.155, ; 155
	ptr @.str.156, ; 156
	ptr @.str.157, ; 157
	ptr @.str.158, ; 158
	ptr @.str.159, ; 159
	ptr @.str.160, ; 160
	ptr @.str.161, ; 161
	ptr @.str.162, ; 162
	ptr @.str.163, ; 163
	ptr @.str.164, ; 164
	ptr @.str.165, ; 165
	ptr @.str.166, ; 166
	ptr @.str.167, ; 167
	ptr @.str.168, ; 168
	ptr @.str.169, ; 169
	ptr @.str.170 ; 170
], align 4

; Strings
@.str.0 = private unnamed_addr constant [35 x i8] c"crc640779913324aae7e9/MainActivity\00", align 1
@.str.1 = private unnamed_addr constant [58 x i8] c"crc640779913324aae7e9/MainActivity_DashboardWebViewClient\00", align 1
@.str.2 = private unnamed_addr constant [60 x i8] c"crc640779913324aae7e9/MainActivity_DashboardWebChromeClient\00", align 1
@.str.3 = private unnamed_addr constant [61 x i8] c"crc640779913324aae7e9/MainActivity_DashboardJavascriptBridge\00", align 1
@.str.4 = private unnamed_addr constant [29 x i8] c"org/xmlpull/v1/XmlPullParser\00", align 1
@.str.5 = private unnamed_addr constant [38 x i8] c"org/xmlpull/v1/XmlPullParserException\00", align 1
@.str.6 = private unnamed_addr constant [32 x i8] c"javax/security/cert/Certificate\00", align 1
@.str.7 = private unnamed_addr constant [36 x i8] c"javax/security/cert/X509Certificate\00", align 1
@.str.8 = private unnamed_addr constant [28 x i8] c"javax/security/auth/Subject\00", align 1
@.str.9 = private unnamed_addr constant [24 x i8] c"javax/net/SocketFactory\00", align 1
@.str.10 = private unnamed_addr constant [33 x i8] c"javax/net/ssl/HttpsURLConnection\00", align 1
@.str.11 = private unnamed_addr constant [31 x i8] c"javax/net/ssl/HostnameVerifier\00", align 1
@.str.12 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/KeyManager\00", align 1
@.str.13 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/SSLSession\00", align 1
@.str.14 = private unnamed_addr constant [32 x i8] c"javax/net/ssl/SSLSessionContext\00", align 1
@.str.15 = private unnamed_addr constant [27 x i8] c"javax/net/ssl/TrustManager\00", align 1
@.str.16 = private unnamed_addr constant [32 x i8] c"javax/net/ssl/KeyManagerFactory\00", align 1
@.str.17 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/SSLContext\00", align 1
@.str.18 = private unnamed_addr constant [31 x i8] c"javax/net/ssl/SSLSocketFactory\00", align 1
@.str.19 = private unnamed_addr constant [34 x i8] c"javax/net/ssl/TrustManagerFactory\00", align 1
@.str.20 = private unnamed_addr constant [30 x i8] c"android/widget/AbsoluteLayout\00", align 1
@.str.21 = private unnamed_addr constant [26 x i8] c"android/widget/AbsSpinner\00", align 1
@.str.22 = private unnamed_addr constant [27 x i8] c"android/widget/AdapterView\00", align 1
@.str.23 = private unnamed_addr constant [28 x i8] c"android/widget/ArrayAdapter\00", align 1
@.str.24 = private unnamed_addr constant [27 x i8] c"android/widget/BaseAdapter\00", align 1
@.str.25 = private unnamed_addr constant [22 x i8] c"android/widget/Button\00", align 1
@.str.26 = private unnamed_addr constant [24 x i8] c"android/widget/EditText\00", align 1
@.str.27 = private unnamed_addr constant [27 x i8] c"android/widget/FrameLayout\00", align 1
@.str.28 = private unnamed_addr constant [40 x i8] c"android/widget/FrameLayout$LayoutParams\00", align 1
@.str.29 = private unnamed_addr constant [23 x i8] c"android/widget/Adapter\00", align 1
@.str.30 = private unnamed_addr constant [30 x i8] c"android/widget/SpinnerAdapter\00", align 1
@.str.31 = private unnamed_addr constant [28 x i8] c"android/widget/LinearLayout\00", align 1
@.str.32 = private unnamed_addr constant [41 x i8] c"android/widget/LinearLayout$LayoutParams\00", align 1
@.str.33 = private unnamed_addr constant [27 x i8] c"android/widget/ProgressBar\00", align 1
@.str.34 = private unnamed_addr constant [26 x i8] c"android/widget/ScrollView\00", align 1
@.str.35 = private unnamed_addr constant [23 x i8] c"android/widget/Spinner\00", align 1
@.str.36 = private unnamed_addr constant [24 x i8] c"android/widget/TextView\00", align 1
@.str.37 = private unnamed_addr constant [47 x i8] c"android/widget/TextView$OnEditorActionListener\00", align 1
@.str.38 = private unnamed_addr constant [63 x i8] c"mono/android/widget/TextView_OnEditorActionListenerImplementor\00", align 1
@.str.39 = private unnamed_addr constant [29 x i8] c"android/webkit/CookieManager\00", align 1
@.str.40 = private unnamed_addr constant [29 x i8] c"android/webkit/ValueCallback\00", align 1
@.str.41 = private unnamed_addr constant [34 x i8] c"android/webkit/WebResourceRequest\00", align 1
@.str.42 = private unnamed_addr constant [24 x i8] c"android/webkit/JsResult\00", align 1
@.str.43 = private unnamed_addr constant [31 x i8] c"android/webkit/WebChromeClient\00", align 1
@.str.44 = private unnamed_addr constant [27 x i8] c"android/webkit/WebSettings\00", align 1
@.str.45 = private unnamed_addr constant [23 x i8] c"android/webkit/WebView\00", align 1
@.str.46 = private unnamed_addr constant [29 x i8] c"android/webkit/WebViewClient\00", align 1
@.str.47 = private unnamed_addr constant [28 x i8] c"android/util/DisplayMetrics\00", align 1
@.str.48 = private unnamed_addr constant [26 x i8] c"android/util/AttributeSet\00", align 1
@.str.49 = private unnamed_addr constant [22 x i8] c"android/os/BaseBundle\00", align 1
@.str.50 = private unnamed_addr constant [17 x i8] c"android/os/Build\00", align 1
@.str.51 = private unnamed_addr constant [25 x i8] c"android/os/Build$VERSION\00", align 1
@.str.52 = private unnamed_addr constant [18 x i8] c"android/os/Bundle\00", align 1
@.str.53 = private unnamed_addr constant [19 x i8] c"android/os/Handler\00", align 1
@.str.54 = private unnamed_addr constant [34 x i8] c"android/os/IBinder$DeathRecipient\00", align 1
@.str.55 = private unnamed_addr constant [19 x i8] c"android/os/IBinder\00", align 1
@.str.56 = private unnamed_addr constant [22 x i8] c"android/os/IInterface\00", align 1
@.str.57 = private unnamed_addr constant [18 x i8] c"android/os/Looper\00", align 1
@.str.58 = private unnamed_addr constant [18 x i8] c"android/os/Parcel\00", align 1
@.str.59 = private unnamed_addr constant [16 x i8] c"android/net/Uri\00", align 1
@.str.60 = private unnamed_addr constant [33 x i8] c"android/database/DataSetObserver\00", align 1
@.str.61 = private unnamed_addr constant [21 x i8] c"android/app/Activity\00", align 1
@.str.62 = private unnamed_addr constant [24 x i8] c"android/app/AlertDialog\00", align 1
@.str.63 = private unnamed_addr constant [32 x i8] c"android/app/AlertDialog$Builder\00", align 1
@.str.64 = private unnamed_addr constant [24 x i8] c"android/app/Application\00", align 1
@.str.65 = private unnamed_addr constant [19 x i8] c"android/app/Dialog\00", align 1
@.str.66 = private unnamed_addr constant [25 x i8] c"android/app/Notification\00", align 1
@.str.67 = private unnamed_addr constant [33 x i8] c"android/app/Notification$Builder\00", align 1
@.str.68 = private unnamed_addr constant [32 x i8] c"android/app/NotificationChannel\00", align 1
@.str.69 = private unnamed_addr constant [32 x i8] c"android/app/NotificationManager\00", align 1
@.str.70 = private unnamed_addr constant [26 x i8] c"android/app/PendingIntent\00", align 1
@.str.71 = private unnamed_addr constant [33 x i8] c"android/view/ContextThemeWrapper\00", align 1
@.str.72 = private unnamed_addr constant [24 x i8] c"android/view/InputEvent\00", align 1
@.str.73 = private unnamed_addr constant [22 x i8] c"android/view/KeyEvent\00", align 1
@.str.74 = private unnamed_addr constant [25 x i8] c"android/view/MotionEvent\00", align 1
@.str.75 = private unnamed_addr constant [18 x i8] c"android/view/View\00", align 1
@.str.76 = private unnamed_addr constant [34 x i8] c"android/view/View$OnClickListener\00", align 1
@.str.77 = private unnamed_addr constant [50 x i8] c"mono/android/view/View_OnClickListenerImplementor\00", align 1
@.str.78 = private unnamed_addr constant [34 x i8] c"android/view/View$OnTouchListener\00", align 1
@.str.79 = private unnamed_addr constant [50 x i8] c"mono/android/view/View_OnTouchListenerImplementor\00", align 1
@.str.80 = private unnamed_addr constant [23 x i8] c"android/view/ViewGroup\00", align 1
@.str.81 = private unnamed_addr constant [36 x i8] c"android/view/ViewGroup$LayoutParams\00", align 1
@.str.82 = private unnamed_addr constant [42 x i8] c"android/view/ViewGroup$MarginLayoutParams\00", align 1
@.str.83 = private unnamed_addr constant [20 x i8] c"android/view/Window\00", align 1
@.str.84 = private unnamed_addr constant [44 x i8] c"android/view/inputmethod/InputMethodManager\00", align 1
@.str.85 = private unnamed_addr constant [40 x i8] c"mono/android/runtime/InputStreamAdapter\00", align 1
@.str.86 = private unnamed_addr constant [31 x i8] c"mono/android/runtime/JavaArray\00", align 1
@.str.87 = private unnamed_addr constant [21 x i8] c"java/util/Collection\00", align 1
@.str.88 = private unnamed_addr constant [18 x i8] c"java/util/HashMap\00", align 1
@.str.89 = private unnamed_addr constant [20 x i8] c"java/util/ArrayList\00", align 1
@.str.90 = private unnamed_addr constant [32 x i8] c"mono/android/runtime/JavaObject\00", align 1
@.str.91 = private unnamed_addr constant [35 x i8] c"android/runtime/JavaProxyThrowable\00", align 1
@.str.92 = private unnamed_addr constant [18 x i8] c"java/util/HashSet\00", align 1
@.str.93 = private unnamed_addr constant [41 x i8] c"mono/android/runtime/OutputStreamAdapter\00", align 1
@.str.94 = private unnamed_addr constant [40 x i8] c"android/runtime/XmlReaderResourceParser\00", align 1
@.str.95 = private unnamed_addr constant [36 x i8] c"android/runtime/XmlReaderPullParser\00", align 1
@.str.96 = private unnamed_addr constant [24 x i8] c"android/graphics/Bitmap\00", align 1
@.str.97 = private unnamed_addr constant [26 x i8] c"android/graphics/Typeface\00", align 1
@.str.98 = private unnamed_addr constant [24 x i8] c"android/content/Context\00", align 1
@.str.99 = private unnamed_addr constant [31 x i8] c"android/content/ContextWrapper\00", align 1
@.str.100 = private unnamed_addr constant [48 x i8] c"android/content/DialogInterface$OnClickListener\00", align 1
@.str.101 = private unnamed_addr constant [64 x i8] c"mono/android/content/DialogInterface_OnClickListenerImplementor\00", align 1
@.str.102 = private unnamed_addr constant [32 x i8] c"android/content/DialogInterface\00", align 1
@.str.103 = private unnamed_addr constant [23 x i8] c"android/content/Intent\00", align 1
@.str.104 = private unnamed_addr constant [41 x i8] c"android/content/SharedPreferences$Editor\00", align 1
@.str.105 = private unnamed_addr constant [67 x i8] c"android/content/SharedPreferences$OnSharedPreferenceChangeListener\00", align 1
@.str.106 = private unnamed_addr constant [34 x i8] c"android/content/SharedPreferences\00", align 1
@.str.107 = private unnamed_addr constant [38 x i8] c"android/content/res/XmlResourceParser\00", align 1
@.str.108 = private unnamed_addr constant [30 x i8] c"android/content/res/Resources\00", align 1
@.str.109 = private unnamed_addr constant [22 x i8] c"java/util/Enumeration\00", align 1
@.str.110 = private unnamed_addr constant [19 x i8] c"java/util/Iterator\00", align 1
@.str.111 = private unnamed_addr constant [17 x i8] c"java/util/Random\00", align 1
@.str.112 = private unnamed_addr constant [28 x i8] c"java/util/function/Consumer\00", align 1
@.str.113 = private unnamed_addr constant [24 x i8] c"java/security/Principal\00", align 1
@.str.114 = private unnamed_addr constant [23 x i8] c"java/security/KeyStore\00", align 1
@.str.115 = private unnamed_addr constant [27 x i8] c"java/security/SecureRandom\00", align 1
@.str.116 = private unnamed_addr constant [31 x i8] c"java/security/cert/Certificate\00", align 1
@.str.117 = private unnamed_addr constant [30 x i8] c"java/nio/channels/FileChannel\00", align 1
@.str.118 = private unnamed_addr constant [51 x i8] c"java/nio/channels/spi/AbstractInterruptibleChannel\00", align 1
@.str.119 = private unnamed_addr constant [26 x i8] c"java/net/ConnectException\00", align 1
@.str.120 = private unnamed_addr constant [27 x i8] c"java/net/HttpURLConnection\00", align 1
@.str.121 = private unnamed_addr constant [27 x i8] c"java/net/InetSocketAddress\00", align 1
@.str.122 = private unnamed_addr constant [27 x i8] c"java/net/ProtocolException\00", align 1
@.str.123 = private unnamed_addr constant [15 x i8] c"java/net/Proxy\00", align 1
@.str.124 = private unnamed_addr constant [20 x i8] c"java/net/Proxy$Type\00", align 1
@.str.125 = private unnamed_addr constant [23 x i8] c"java/net/SocketAddress\00", align 1
@.str.126 = private unnamed_addr constant [25 x i8] c"java/net/SocketException\00", align 1
@.str.127 = private unnamed_addr constant [32 x i8] c"java/net/SocketTimeoutException\00", align 1
@.str.128 = private unnamed_addr constant [33 x i8] c"java/net/UnknownServiceException\00", align 1
@.str.129 = private unnamed_addr constant [13 x i8] c"java/net/URL\00", align 1
@.str.130 = private unnamed_addr constant [23 x i8] c"java/net/URLConnection\00", align 1
@.str.131 = private unnamed_addr constant [23 x i8] c"java/io/FileDescriptor\00", align 1
@.str.132 = private unnamed_addr constant [24 x i8] c"java/io/FileInputStream\00", align 1
@.str.133 = private unnamed_addr constant [20 x i8] c"java/io/InputStream\00", align 1
@.str.134 = private unnamed_addr constant [31 x i8] c"java/io/InterruptedIOException\00", align 1
@.str.135 = private unnamed_addr constant [20 x i8] c"java/io/IOException\00", align 1
@.str.136 = private unnamed_addr constant [21 x i8] c"java/io/OutputStream\00", align 1
@.str.137 = private unnamed_addr constant [20 x i8] c"java/io/PrintWriter\00", align 1
@.str.138 = private unnamed_addr constant [15 x i8] c"java/io/Reader\00", align 1
@.str.139 = private unnamed_addr constant [21 x i8] c"java/io/StringWriter\00", align 1
@.str.140 = private unnamed_addr constant [15 x i8] c"java/io/Writer\00", align 1
@.str.141 = private unnamed_addr constant [18 x i8] c"java/lang/Boolean\00", align 1
@.str.142 = private unnamed_addr constant [15 x i8] c"java/lang/Byte\00", align 1
@.str.143 = private unnamed_addr constant [20 x i8] c"java/lang/Character\00", align 1
@.str.144 = private unnamed_addr constant [16 x i8] c"java/lang/Class\00", align 1
@.str.145 = private unnamed_addr constant [29 x i8] c"java/lang/ClassCastException\00", align 1
@.str.146 = private unnamed_addr constant [17 x i8] c"java/lang/Double\00", align 1
@.str.147 = private unnamed_addr constant [15 x i8] c"java/lang/Enum\00", align 1
@.str.148 = private unnamed_addr constant [16 x i8] c"java/lang/Error\00", align 1
@.str.149 = private unnamed_addr constant [20 x i8] c"java/lang/Exception\00", align 1
@.str.150 = private unnamed_addr constant [16 x i8] c"java/lang/Float\00", align 1
@.str.151 = private unnamed_addr constant [23 x i8] c"java/lang/CharSequence\00", align 1
@.str.152 = private unnamed_addr constant [35 x i8] c"java/lang/IllegalArgumentException\00", align 1
@.str.153 = private unnamed_addr constant [32 x i8] c"java/lang/IllegalStateException\00", align 1
@.str.154 = private unnamed_addr constant [36 x i8] c"java/lang/IndexOutOfBoundsException\00", align 1
@.str.155 = private unnamed_addr constant [18 x i8] c"java/lang/Integer\00", align 1
@.str.156 = private unnamed_addr constant [19 x i8] c"java/lang/Runnable\00", align 1
@.str.157 = private unnamed_addr constant [15 x i8] c"java/lang/Long\00", align 1
@.str.158 = private unnamed_addr constant [31 x i8] c"java/lang/NullPointerException\00", align 1
@.str.159 = private unnamed_addr constant [17 x i8] c"java/lang/Number\00", align 1
@.str.160 = private unnamed_addr constant [17 x i8] c"java/lang/Object\00", align 1
@.str.161 = private unnamed_addr constant [27 x i8] c"java/lang/RuntimeException\00", align 1
@.str.162 = private unnamed_addr constant [28 x i8] c"java/lang/SecurityException\00", align 1
@.str.163 = private unnamed_addr constant [16 x i8] c"java/lang/Short\00", align 1
@.str.164 = private unnamed_addr constant [28 x i8] c"java/lang/StackTraceElement\00", align 1
@.str.165 = private unnamed_addr constant [17 x i8] c"java/lang/String\00", align 1
@.str.166 = private unnamed_addr constant [17 x i8] c"java/lang/Thread\00", align 1
@.str.167 = private unnamed_addr constant [35 x i8] c"mono/java/lang/RunnableImplementor\00", align 1
@.str.168 = private unnamed_addr constant [20 x i8] c"java/lang/Throwable\00", align 1
@.str.169 = private unnamed_addr constant [40 x i8] c"java/lang/UnsupportedOperationException\00", align 1
@.str.170 = private unnamed_addr constant [25 x i8] c"mono/android/TypeManager\00", align 1

;TypeMapModule
@.TypeMapModule.0_assembly_name = private unnamed_addr constant [23 x i8] c"PisonetManager.Android\00", align 1
@.TypeMapModule.1_assembly_name = private unnamed_addr constant [13 x i8] c"Mono.Android\00", align 1

; Metadata
!llvm.module.flags = !{!0, !1, !7}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.4xx @ 82d8938cf80f6d5fa6c28529ddfbdb753d805ab4"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"NumRegisterParameters", i32 0}
