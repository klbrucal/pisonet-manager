; ModuleID = 'typemaps.x86_64.ll'
source_filename = "typemaps.x86_64.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-android21"

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
		[16 x i8] c"&sV\22\81B[D\AE\CA\94?\1D\E8\8E)", ; module_uuid: 22567326-4281-445b-aeca-943f1de88e29
		i32 167, ; uint32_t entry_count (0xa7)
		i32 63, ; uint32_t duplicate_count (0x3f)
		ptr @module0_managed_to_java, ; TypeMapModuleEntry* map
		ptr @module0_managed_to_java_duplicates, ; TypeMapModuleEntry* duplicate_map
		ptr @.TypeMapModule.0_assembly_name, ; assembly_name: Mono.Android
		ptr null, ; MonoImage* image
		i32 0, ; uint32_t java_name_width (0x0)
		ptr null; uint8_t* java_map (0x0)
	}, ; 0
	%struct.TypeMapModule {
		[16 x i8] c"\FA\12\07\8E\1C\13\A0G\89\04\01>\B3`&\18", ; module_uuid: 8e0712fa-131c-47a0-8904-013eb3602618
		i32 4, ; uint32_t entry_count (0x4)
		i32 0, ; uint32_t duplicate_count (0x0)
		ptr @module1_managed_to_java, ; TypeMapModuleEntry* map
		ptr null, ; TypeMapModuleEntry* duplicate_map
		ptr @.TypeMapModule.1_assembly_name, ; assembly_name: PisonetManager.Android
		ptr null, ; MonoImage* image
		i32 0, ; uint32_t java_name_width (0x0)
		ptr null; uint8_t* java_map (0x0)
	} ; 1
], align 16

; Java types name hashes
@map_java_hashes = dso_local local_unnamed_addr constant [171 x i64] [
	i64 128182020419974451, ; 0: 0x1c764de51b97533 => java/lang/String
	i64 318564728890166633, ; 1: 0x46bc4eedf778d69 => android/widget/Button
	i64 361870449891484378, ; 2: 0x5059f41c47e22da => android/os/Bundle
	i64 363417747702605178, ; 3: 0x50b1e841ce2e57a => android/widget/TextView
	i64 515916014736443504, ; 4: 0x728e6e1c84d0870 => android/webkit/ValueCallback
	i64 698692053645229055, ; 5: 0x9b240b890e97bff => javax/net/ssl/HttpsURLConnection
	i64 698738878519169148, ; 6: 0x9b26b4ed4e3d07c => mono/android/content/DialogInterface_OnClickListenerImplementor
	i64 705175846315662030, ; 7: 0x9c949b22fd49ace => android/view/MotionEvent
	i64 870874870088288028, ; 8: 0xc15f8148b6d471c => java/lang/Exception
	i64 994850409983335970, ; 9: 0xdce6b2d4bb55e22 => android/app/NotificationManager
	i64 1079586186822872943, ; 10: 0xefb75eac1feef6f => java/util/function/Consumer
	i64 1217044833273073796, ; 11: 0x10e3cfd3e2f75084 => java/util/HashSet
	i64 1283121375857603354, ; 12: 0x11ce9017d3b3f31a => java/net/ConnectException
	i64 1317579852464953526, ; 13: 0x1248fbe51d6298b6 => java/io/FileInputStream
	i64 1320822650197077237, ; 14: 0x12548133cc496cf5 => android/runtime/JavaProxyThrowable
	i64 1362770524300979611, ; 15: 0x12e9889253552d9b => java/util/Iterator
	i64 1550860884384862055, ; 16: 0x1585c3c1edcecf67 => java/net/ProtocolException
	i64 1747499027921055994, ; 17: 0x18405d1b749330fa => android/os/BaseBundle
	i64 1831728799718484971, ; 18: 0x196b9ba37012abeb => java/io/IOException
	i64 1877272793125324469, ; 19: 0x1a0d69a8bcbd86b5 => java/net/Proxy
	i64 2111352555338672611, ; 20: 0x1d4d07f6709329e3 => android/view/InputEvent
	i64 2157468975174833820, ; 21: 0x1df0de9a2738d69c => org/xmlpull/v1/XmlPullParserException
	i64 2164140653916027403, ; 22: 0x1e08927568a57a0b => java/io/InputStream
	i64 2266689907793747123, ; 23: 0x1f74e67632025cb3 => java/net/HttpURLConnection
	i64 2319268360137032813, ; 24: 0x202fb24918c5446d => java/security/SecureRandom
	i64 2542726837267699812, ; 25: 0x2349949628319864 => android/view/Window
	i64 2603260641783996945, ; 26: 0x2420a3c2d34a6211 => android/view/inputmethod/InputMethodManager
	i64 2972252214977986258, ; 27: 0x293f8fa450a17ed2 => android/content/Intent
	i64 3071747017624329461, ; 28: 0x2aa109a3415d1cf5 => android/os/Build
	i64 3145165272272586806, ; 29: 0x2ba5df26bdb3c836 => android/widget/ScrollView
	i64 3149091779324127856, ; 30: 0x2bb3d249e7b7aa70 => crc640779913324aae7e9/MainActivity_DashboardWebViewClient
	i64 3312753486604898190, ; 31: 0x2df943be8d858f8e => android/app/Dialog
	i64 3476617847597562063, ; 32: 0x303f6d8331d5f8cf => java/io/PrintWriter
	i64 3492966660860961054, ; 33: 0x307982abe8e6611e => android/widget/AdapterView
	i64 3530631042196079534, ; 34: 0x30ff523a0f1083ae => android/content/DialogInterface
	i64 3656396631051491790, ; 35: 0x32be215d0fc259ce => java/net/InetSocketAddress
	i64 3880992763041431256, ; 36: 0x35dc0e5b08f23ed8 => android/widget/SpinnerAdapter
	i64 3936478700004404583, ; 37: 0x36a12e8573a76d67 => java/net/SocketAddress
	i64 3957166361670620563, ; 38: 0x36eaadd708809593 => javax/security/cert/Certificate
	i64 4124081207344523115, ; 39: 0x393bae01fca2676b => android/webkit/JsResult
	i64 4175515025192399737, ; 40: 0x39f268cae6e63379 => android/widget/ArrayAdapter
	i64 4216519898928517408, ; 41: 0x3a8416820c001120 => android/os/IInterface
	i64 4305371449952891808, ; 42: 0x3bbfc085dc8cf3a0 => java/lang/Class
	i64 4328468547648071486, ; 43: 0x3c11cf35fc03a73e => android/net/Uri
	i64 4590799101254748484, ; 44: 0x3fb5cb75a178c944 => javax/net/ssl/TrustManagerFactory
	i64 4672418894112007217, ; 45: 0x40d7c43a895ea431 => android/webkit/WebSettings
	i64 4756101769800025001, ; 46: 0x4201115c588983a9 => javax/net/SocketFactory
	i64 5214467817578676657, ; 47: 0x485d82da477bc1b1 => java/lang/Error
	i64 5298993295171134929, ; 48: 0x4989ce53a1da25d1 => android/runtime/XmlReaderResourceParser
	i64 5793982059409158284, ; 49: 0x50685bfc3611b08c => java/net/URLConnection
	i64 5856823971975629766, ; 50: 0x51479e5f29998bc6 => android/widget/LinearLayout$LayoutParams
	i64 5890385405214755341, ; 51: 0x51beda5143f88a0d => android/widget/FrameLayout
	i64 5928119462157283979, ; 52: 0x5244e93e07f6f28b => android/widget/Adapter
	i64 5991054489085362647, ; 53: 0x53248050dbf141d7 => javax/security/cert/X509Certificate
	i64 6000768439507874839, ; 54: 0x5347031a303df417 => java/lang/Enum
	i64 6116679261601087867, ; 55: 0x54e2cf6180bb417b => android/widget/LinearLayout
	i64 6740334783866200195, ; 56: 0x5d8a7ac62b8de083 => javax/net/ssl/SSLSession
	i64 7048179316721281784, ; 57: 0x61d029bee66d6af8 => mono/android/widget/TextView_OnEditorActionListenerImplementor
	i64 7291810569935423650, ; 58: 0x6531b714667088a2 => android/os/Build$VERSION
	i64 7437796681088239247, ; 59: 0x67385cac9fd8068f => java/io/FileDescriptor
	i64 7620119821450638162, ; 60: 0x69c01a9abf7a7352 => java/io/InterruptedIOException
	i64 7658195837123306865, ; 61: 0x6a476089fc1c2571 => java/lang/Character
	i64 7933543037734065265, ; 62: 0x6e199b5bee699471 => java/util/HashMap
	i64 7977746367831656039, ; 63: 0x6eb6a60dbac4c667 => android/widget/ProgressBar
	i64 7983078697141197390, ; 64: 0x6ec997c76516da4e => mono/android/view/View_OnTouchListenerImplementor
	i64 8144041705376199321, ; 65: 0x710572c834ea3299 => android/app/NotificationChannel
	i64 8190305621607579207, ; 66: 0x71a9cf9199cdfe47 => java/nio/channels/spi/AbstractInterruptibleChannel
	i64 8297633541287010709, ; 67: 0x73271dbe38c76195 => android/app/Notification$Builder
	i64 8346035133485678443, ; 68: 0x73d312bc1657ff6b => crc640779913324aae7e9/MainActivity_DashboardWebChromeClient
	i64 8416619862292774857, ; 69: 0x74cdd72bed753fc9 => java/lang/IllegalArgumentException
	i64 8462361838522003613, ; 70: 0x75705941b1ecf09d => android/os/IBinder
	i64 8487642170263250902, ; 71: 0x75ca29959b2aa7d6 => android/content/ContextWrapper
	i64 8587172038193766563, ; 72: 0x772bc378d1b4e0a3 => java/lang/Runnable
	i64 8722435519081898203, ; 73: 0x790c50e4232060db => android/app/PendingIntent
	i64 8950391188589719199, ; 74: 0x7c362d5d64ad2e9f => java/lang/Boolean
	i64 9000742728442691829, ; 75: 0x7ce90fd2d381c0f5 => java/io/Reader
	i64 9039115063128758362, ; 76: 0x7d71634235ac185a => android/webkit/CookieManager
	i64 9154019302997878316, ; 77: 0x7f099c0e5641e62c => javax/net/ssl/KeyManager
	i64 9187009981601112352, ; 78: 0x7f7ed0e7454d6120 => android/view/ViewGroup$MarginLayoutParams
	i64 9217569019755338609, ; 79: 0x7feb622fcb299b71 => java/security/Principal
	i64 9374080444557732201, ; 80: 0x82176c7f91cca969 => android/os/IBinder$DeathRecipient
	i64 9438692839722425326, ; 81: 0x82fcf9211fad9bee => crc640779913324aae7e9/MainActivity
	i64 9667515047141612341, ; 82: 0x8629e9b6f59e9b35 => java/lang/Thread
	i64 9785570804745343508, ; 83: 0x87cd54ccfd479214 => java/net/URL
	i64 9866983915955550238, ; 84: 0x88ee91981305f81e => java/lang/SecurityException
	i64 9869939015140501507, ; 85: 0x88f9113db837e803 => android/app/Activity
	i64 9977296435420958008, ; 86: 0x8a767a3efc098d38 => java/lang/NullPointerException
	i64 10266059374509936169, ; 87: 0x8e785e9bf4bbce29 => java/lang/Long
	i64 10499957734077086001, ; 88: 0x91b757ed9047b931 => android/view/ViewGroup$LayoutParams
	i64 10589642565195629679, ; 89: 0x92f5f7ce84d7846f => java/lang/UnsupportedOperationException
	i64 10722894652849872693, ; 90: 0x94cf5fdfdb0d5f35 => java/lang/Short
	i64 10808978037618020601, ; 91: 0x96013441bd3890f9 => android/database/DataSetObserver
	i64 11005920483369566278, ; 92: 0x98bce25e25704046 => java/util/Random
	i64 11112718717483603117, ; 93: 0x9a384ecbbc71d4ad => android/os/Handler
	i64 11393831178655295976, ; 94: 0x9e1f05170284e9e8 => javax/net/ssl/SSLContext
	i64 11573301743732151818, ; 95: 0xa09ca09e3190560a => mono/java/lang/RunnableImplementor
	i64 11585998938245262039, ; 96: 0xa0c9bca62a296ad7 => mono/android/runtime/JavaArray
	i64 11712899692065226922, ; 97: 0xa28c94365b5480aa => java/util/ArrayList
	i64 11763058807128842702, ; 98: 0xa33ec7a966f1e1ce => java/security/cert/Certificate
	i64 11954228872253987625, ; 99: 0xa5e5f3d2b66adb29 => android/view/View
	i64 12016049636675011370, ; 100: 0xa6c1957b1579c32a => android/widget/EditText
	i64 12228984007958404582, ; 101: 0xa9b61429ce4b1de6 => android/content/Context
	i64 12426529965699990912, ; 102: 0xac73e72a4c4b8580 => java/lang/IndexOutOfBoundsException
	i64 12458575303368155603, ; 103: 0xace5c03ae4b6a1d3 => android/content/res/Resources
	i64 12476375190645835422, ; 104: 0xad24fd221af1069e => android/os/Looper
	i64 12488842103917764438, ; 105: 0xad5147b98bf5df56 => java/lang/IllegalStateException
	i64 12532121860257401396, ; 106: 0xadeb0a6f128cca34 => java/lang/Number
	i64 12610567535961206755, ; 107: 0xaf01bc5c3d0a6fe3 => android/widget/AbsSpinner
	i64 12806567541869262104, ; 108: 0xb1ba1153c52a3518 => java/lang/Integer
	i64 12882710959019299141, ; 109: 0xb2c8955c98609145 => java/net/SocketTimeoutException
	i64 13046320909237610371, ; 110: 0xb50dd7be9cdbe783 => android/content/res/XmlResourceParser
	i64 13191394589072141775, ; 111: 0xb7113f7cdda7adcf => android/app/AlertDialog$Builder
	i64 13291009470876803657, ; 112: 0xb87326b1e9f6e249 => android/app/Notification
	i64 13402779434266666368, ; 113: 0xba003ce26e602580 => mono/android/TypeManager
	i64 13491848569179882038, ; 114: 0xbb3cacca71544236 => android/app/AlertDialog
	i64 13502560151794130917, ; 115: 0xbb62baeb1e089fe5 => javax/security/auth/Subject
	i64 13556576098032765635, ; 116: 0xbc22a222a5cb4ac3 => android/util/DisplayMetrics
	i64 13770727111868296170, ; 117: 0xbf1b735909c02bea => java/io/StringWriter
	i64 13789203013919682202, ; 118: 0xbf5d1715346dae9a => java/lang/RuntimeException
	i64 13805562342397192842, ; 119: 0xbf9735ce2f182a8a => android/util/AttributeSet
	i64 13877554026709814142, ; 120: 0xc096f9dc61548b7e => android/view/View$OnClickListener
	i64 13959986462581077347, ; 121: 0xc1bbd5b97b683563 => java/net/UnknownServiceException
	i64 13975325537152167595, ; 122: 0xc1f2548816666eab => android/graphics/Typeface
	i64 14031640676547298208, ; 123: 0xc2ba66da3d8603a0 => java/nio/channels/FileChannel
	i64 14160925941038085484, ; 124: 0xc485b71d9630756c => javax/net/ssl/KeyManagerFactory
	i64 14167891754637755728, ; 125: 0xc49e767c735e8550 => java/lang/Object
	i64 14180814796703042768, ; 126: 0xc4cc5feca7168cd0 => java/lang/ClassCastException
	i64 14206023932851353817, ; 127: 0xc525ef800c4d78d9 => mono/android/runtime/OutputStreamAdapter
	i64 14279287371309537477, ; 128: 0xc62a383594a058c5 => android/view/View$OnTouchListener
	i64 14296237994325564878, ; 129: 0xc66670b60c37ddce => android/content/SharedPreferences
	i64 14361620789319229198, ; 130: 0xc74eba044a3cdf0e => android/os/Parcel
	i64 14501341618205132561, ; 131: 0xc93f1d5ecfb48711 => java/lang/Byte
	i64 14640111878662023944, ; 132: 0xcb2c202fdfa06b08 => android/webkit/WebChromeClient
	i64 14649586819325063784, ; 133: 0xcb4dc998681d7268 => mono/android/view/View_OnClickListenerImplementor
	i64 14684559126920293129, ; 134: 0xcbca08b94b4deb09 => java/lang/CharSequence
	i64 14717452127296789712, ; 135: 0xcc3ee4bbbe579cd0 => android/widget/TextView$OnEditorActionListener
	i64 14940408132235664607, ; 136: 0xcf56fe09e1439cdf => java/lang/Throwable
	i64 15142650489578038267, ; 137: 0xd22580641d31a3fb => java/lang/StackTraceElement
	i64 15178898666151156562, ; 138: 0xd2a647ea65971b52 => javax/net/ssl/HostnameVerifier
	i64 15183122999177041308, ; 139: 0xd2b549ec9302d59c => org/xmlpull/v1/XmlPullParser
	i64 15227253633559603018, ; 140: 0xd35212809518a74a => android/widget/Spinner
	i64 15367873893566575642, ; 141: 0xd545a7e23b08f41a => android/widget/AbsoluteLayout
	i64 15446304586598055563, ; 142: 0xd65c4c2ef8a9fe8b => android/webkit/WebResourceRequest
	i64 15633873768898914415, ; 143: 0xd8f6ad5c6a84686f => java/io/Writer
	i64 15767615218119146656, ; 144: 0xdad1d2801f08fca0 => javax/net/ssl/SSLSessionContext
	i64 15888603495552893685, ; 145: 0xdc7fa8b2a175c2f5 => javax/net/ssl/TrustManager
	i64 15896143924811176167, ; 146: 0xdc9a72ada0da98e7 => java/net/SocketException
	i64 16003229482241506982, ; 147: 0xde16e46ce4103ea6 => android/graphics/Bitmap
	i64 16066423801151412293, ; 148: 0xdef76752d682d845 => android/runtime/XmlReaderPullParser
	i64 16101147842785907581, ; 149: 0xdf72c4a7cd4d137d => android/webkit/WebViewClient
	i64 16314168557433322311, ; 150: 0xe26791dde7a8fb47 => android/view/ContextThemeWrapper
	i64 16413651262945443612, ; 151: 0xe3c900dc43013f1c => android/content/DialogInterface$OnClickListener
	i64 16542847110558016359, ; 152: 0xe593ffcc9e686367 => android/app/Application
	i64 16603717322881265010, ; 153: 0xe66c40ef55566d72 => mono/android/runtime/JavaObject
	i64 16723123314454325679, ; 154: 0xe814780d351a69af => mono/android/runtime/InputStreamAdapter
	i64 16832017439803262409, ; 155: 0xe99756ae80a745c9 => android/view/ViewGroup
	i64 16878061737430998064, ; 156: 0xea3aebb9f4afdc30 => android/content/SharedPreferences$Editor
	i64 16953366867418781877, ; 157: 0xeb467557d75f98b5 => android/widget/FrameLayout$LayoutParams
	i64 17125416866214736517, ; 158: 0xeda9b3e7cd367285 => java/io/OutputStream
	i64 17312589003384955623, ; 159: 0xf042abf8f91822e7 => android/view/KeyEvent
	i64 17490083481060646178, ; 160: 0xf2b94242748c1d22 => java/util/Enumeration
	i64 17498018958444438720, ; 161: 0xf2d57388c321a4c0 => java/lang/Double
	i64 17519581955836770800, ; 162: 0xf3220ef752fe79f0 => java/security/KeyStore
	i64 17605619666541934257, ; 163: 0xf453b9cee2dcf6b1 => java/net/Proxy$Type
	i64 17882928931947605280, ; 164: 0xf82ced1da44aed20 => crc640779913324aae7e9/MainActivity_DashboardJavascriptBridge
	i64 17992660388602075186, ; 165: 0xf9b2c54b52de5832 => android/webkit/WebView
	i64 18213852175163534091, ; 166: 0xfcc49a0d5c192b0b => android/content/SharedPreferences$OnSharedPreferenceChangeListener
	i64 18216578448169670053, ; 167: 0xfcce4995423095a5 => javax/net/ssl/SSLSocketFactory
	i64 18323076787180290332, ; 168: 0xfe48a5421416411c => android/widget/BaseAdapter
	i64 18401512074820890716, ; 169: 0xff5f4dbc95c2b05c => java/lang/Float
	i64 18401692079723824300 ; 170: 0xff5ff1733e0ec4ac => java/util/Collection
], align 16

@module0_managed_to_java = internal dso_local constant [167 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554533, ; uint32_t type_token_id (0x2000065)
		i32 139; uint32_t java_map_index (0x8b)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554535, ; uint32_t type_token_id (0x2000067)
		i32 21; uint32_t java_map_index (0x15)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554537, ; uint32_t type_token_id (0x2000069)
		i32 38; uint32_t java_map_index (0x26)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554539, ; uint32_t type_token_id (0x200006b)
		i32 53; uint32_t java_map_index (0x35)
	}, ; 3
	%struct.TypeMapModuleEntry {
		i32 33554541, ; uint32_t type_token_id (0x200006d)
		i32 115; uint32_t java_map_index (0x73)
	}, ; 4
	%struct.TypeMapModuleEntry {
		i32 33554542, ; uint32_t type_token_id (0x200006e)
		i32 46; uint32_t java_map_index (0x2e)
	}, ; 5
	%struct.TypeMapModuleEntry {
		i32 33554544, ; uint32_t type_token_id (0x2000070)
		i32 5; uint32_t java_map_index (0x5)
	}, ; 6
	%struct.TypeMapModuleEntry {
		i32 33554546, ; uint32_t type_token_id (0x2000072)
		i32 138; uint32_t java_map_index (0x8a)
	}, ; 7
	%struct.TypeMapModuleEntry {
		i32 33554548, ; uint32_t type_token_id (0x2000074)
		i32 77; uint32_t java_map_index (0x4d)
	}, ; 8
	%struct.TypeMapModuleEntry {
		i32 33554550, ; uint32_t type_token_id (0x2000076)
		i32 56; uint32_t java_map_index (0x38)
	}, ; 9
	%struct.TypeMapModuleEntry {
		i32 33554552, ; uint32_t type_token_id (0x2000078)
		i32 144; uint32_t java_map_index (0x90)
	}, ; 10
	%struct.TypeMapModuleEntry {
		i32 33554554, ; uint32_t type_token_id (0x200007a)
		i32 145; uint32_t java_map_index (0x91)
	}, ; 11
	%struct.TypeMapModuleEntry {
		i32 33554556, ; uint32_t type_token_id (0x200007c)
		i32 124; uint32_t java_map_index (0x7c)
	}, ; 12
	%struct.TypeMapModuleEntry {
		i32 33554557, ; uint32_t type_token_id (0x200007d)
		i32 94; uint32_t java_map_index (0x5e)
	}, ; 13
	%struct.TypeMapModuleEntry {
		i32 33554558, ; uint32_t type_token_id (0x200007e)
		i32 167; uint32_t java_map_index (0xa7)
	}, ; 14
	%struct.TypeMapModuleEntry {
		i32 33554560, ; uint32_t type_token_id (0x2000080)
		i32 44; uint32_t java_map_index (0x2c)
	}, ; 15
	%struct.TypeMapModuleEntry {
		i32 33554561, ; uint32_t type_token_id (0x2000081)
		i32 141; uint32_t java_map_index (0x8d)
	}, ; 16
	%struct.TypeMapModuleEntry {
		i32 33554562, ; uint32_t type_token_id (0x2000082)
		i32 107; uint32_t java_map_index (0x6b)
	}, ; 17
	%struct.TypeMapModuleEntry {
		i32 33554564, ; uint32_t type_token_id (0x2000084)
		i32 33; uint32_t java_map_index (0x21)
	}, ; 18
	%struct.TypeMapModuleEntry {
		i32 33554566, ; uint32_t type_token_id (0x2000086)
		i32 40; uint32_t java_map_index (0x28)
	}, ; 19
	%struct.TypeMapModuleEntry {
		i32 33554567, ; uint32_t type_token_id (0x2000087)
		i32 168; uint32_t java_map_index (0xa8)
	}, ; 20
	%struct.TypeMapModuleEntry {
		i32 33554569, ; uint32_t type_token_id (0x2000089)
		i32 1; uint32_t java_map_index (0x1)
	}, ; 21
	%struct.TypeMapModuleEntry {
		i32 33554570, ; uint32_t type_token_id (0x200008a)
		i32 100; uint32_t java_map_index (0x64)
	}, ; 22
	%struct.TypeMapModuleEntry {
		i32 33554571, ; uint32_t type_token_id (0x200008b)
		i32 51; uint32_t java_map_index (0x33)
	}, ; 23
	%struct.TypeMapModuleEntry {
		i32 33554572, ; uint32_t type_token_id (0x200008c)
		i32 157; uint32_t java_map_index (0x9d)
	}, ; 24
	%struct.TypeMapModuleEntry {
		i32 33554573, ; uint32_t type_token_id (0x200008d)
		i32 52; uint32_t java_map_index (0x34)
	}, ; 25
	%struct.TypeMapModuleEntry {
		i32 33554575, ; uint32_t type_token_id (0x200008f)
		i32 36; uint32_t java_map_index (0x24)
	}, ; 26
	%struct.TypeMapModuleEntry {
		i32 33554577, ; uint32_t type_token_id (0x2000091)
		i32 55; uint32_t java_map_index (0x37)
	}, ; 27
	%struct.TypeMapModuleEntry {
		i32 33554578, ; uint32_t type_token_id (0x2000092)
		i32 50; uint32_t java_map_index (0x32)
	}, ; 28
	%struct.TypeMapModuleEntry {
		i32 33554579, ; uint32_t type_token_id (0x2000093)
		i32 63; uint32_t java_map_index (0x3f)
	}, ; 29
	%struct.TypeMapModuleEntry {
		i32 33554580, ; uint32_t type_token_id (0x2000094)
		i32 29; uint32_t java_map_index (0x1d)
	}, ; 30
	%struct.TypeMapModuleEntry {
		i32 33554581, ; uint32_t type_token_id (0x2000095)
		i32 140; uint32_t java_map_index (0x8c)
	}, ; 31
	%struct.TypeMapModuleEntry {
		i32 33554582, ; uint32_t type_token_id (0x2000096)
		i32 3; uint32_t java_map_index (0x3)
	}, ; 32
	%struct.TypeMapModuleEntry {
		i32 33554583, ; uint32_t type_token_id (0x2000097)
		i32 135; uint32_t java_map_index (0x87)
	}, ; 33
	%struct.TypeMapModuleEntry {
		i32 33554586, ; uint32_t type_token_id (0x200009a)
		i32 57; uint32_t java_map_index (0x39)
	}, ; 34
	%struct.TypeMapModuleEntry {
		i32 33554593, ; uint32_t type_token_id (0x20000a1)
		i32 76; uint32_t java_map_index (0x4c)
	}, ; 35
	%struct.TypeMapModuleEntry {
		i32 33554595, ; uint32_t type_token_id (0x20000a3)
		i32 4; uint32_t java_map_index (0x4)
	}, ; 36
	%struct.TypeMapModuleEntry {
		i32 33554597, ; uint32_t type_token_id (0x20000a5)
		i32 142; uint32_t java_map_index (0x8e)
	}, ; 37
	%struct.TypeMapModuleEntry {
		i32 33554600, ; uint32_t type_token_id (0x20000a8)
		i32 39; uint32_t java_map_index (0x27)
	}, ; 38
	%struct.TypeMapModuleEntry {
		i32 33554601, ; uint32_t type_token_id (0x20000a9)
		i32 132; uint32_t java_map_index (0x84)
	}, ; 39
	%struct.TypeMapModuleEntry {
		i32 33554602, ; uint32_t type_token_id (0x20000aa)
		i32 45; uint32_t java_map_index (0x2d)
	}, ; 40
	%struct.TypeMapModuleEntry {
		i32 33554604, ; uint32_t type_token_id (0x20000ac)
		i32 165; uint32_t java_map_index (0xa5)
	}, ; 41
	%struct.TypeMapModuleEntry {
		i32 33554605, ; uint32_t type_token_id (0x20000ad)
		i32 149; uint32_t java_map_index (0x95)
	}, ; 42
	%struct.TypeMapModuleEntry {
		i32 33554606, ; uint32_t type_token_id (0x20000ae)
		i32 116; uint32_t java_map_index (0x74)
	}, ; 43
	%struct.TypeMapModuleEntry {
		i32 33554607, ; uint32_t type_token_id (0x20000af)
		i32 119; uint32_t java_map_index (0x77)
	}, ; 44
	%struct.TypeMapModuleEntry {
		i32 33554610, ; uint32_t type_token_id (0x20000b2)
		i32 17; uint32_t java_map_index (0x11)
	}, ; 45
	%struct.TypeMapModuleEntry {
		i32 33554611, ; uint32_t type_token_id (0x20000b3)
		i32 28; uint32_t java_map_index (0x1c)
	}, ; 46
	%struct.TypeMapModuleEntry {
		i32 33554612, ; uint32_t type_token_id (0x20000b4)
		i32 58; uint32_t java_map_index (0x3a)
	}, ; 47
	%struct.TypeMapModuleEntry {
		i32 33554613, ; uint32_t type_token_id (0x20000b5)
		i32 2; uint32_t java_map_index (0x2)
	}, ; 48
	%struct.TypeMapModuleEntry {
		i32 33554614, ; uint32_t type_token_id (0x20000b6)
		i32 93; uint32_t java_map_index (0x5d)
	}, ; 49
	%struct.TypeMapModuleEntry {
		i32 33554615, ; uint32_t type_token_id (0x20000b7)
		i32 80; uint32_t java_map_index (0x50)
	}, ; 50
	%struct.TypeMapModuleEntry {
		i32 33554617, ; uint32_t type_token_id (0x20000b9)
		i32 70; uint32_t java_map_index (0x46)
	}, ; 51
	%struct.TypeMapModuleEntry {
		i32 33554619, ; uint32_t type_token_id (0x20000bb)
		i32 41; uint32_t java_map_index (0x29)
	}, ; 52
	%struct.TypeMapModuleEntry {
		i32 33554621, ; uint32_t type_token_id (0x20000bd)
		i32 104; uint32_t java_map_index (0x68)
	}, ; 53
	%struct.TypeMapModuleEntry {
		i32 33554622, ; uint32_t type_token_id (0x20000be)
		i32 130; uint32_t java_map_index (0x82)
	}, ; 54
	%struct.TypeMapModuleEntry {
		i32 33554625, ; uint32_t type_token_id (0x20000c1)
		i32 43; uint32_t java_map_index (0x2b)
	}, ; 55
	%struct.TypeMapModuleEntry {
		i32 33554627, ; uint32_t type_token_id (0x20000c3)
		i32 91; uint32_t java_map_index (0x5b)
	}, ; 56
	%struct.TypeMapModuleEntry {
		i32 33554630, ; uint32_t type_token_id (0x20000c6)
		i32 85; uint32_t java_map_index (0x55)
	}, ; 57
	%struct.TypeMapModuleEntry {
		i32 33554631, ; uint32_t type_token_id (0x20000c7)
		i32 114; uint32_t java_map_index (0x72)
	}, ; 58
	%struct.TypeMapModuleEntry {
		i32 33554632, ; uint32_t type_token_id (0x20000c8)
		i32 111; uint32_t java_map_index (0x6f)
	}, ; 59
	%struct.TypeMapModuleEntry {
		i32 33554633, ; uint32_t type_token_id (0x20000c9)
		i32 152; uint32_t java_map_index (0x98)
	}, ; 60
	%struct.TypeMapModuleEntry {
		i32 33554634, ; uint32_t type_token_id (0x20000ca)
		i32 31; uint32_t java_map_index (0x1f)
	}, ; 61
	%struct.TypeMapModuleEntry {
		i32 33554635, ; uint32_t type_token_id (0x20000cb)
		i32 112; uint32_t java_map_index (0x70)
	}, ; 62
	%struct.TypeMapModuleEntry {
		i32 33554636, ; uint32_t type_token_id (0x20000cc)
		i32 67; uint32_t java_map_index (0x43)
	}, ; 63
	%struct.TypeMapModuleEntry {
		i32 33554637, ; uint32_t type_token_id (0x20000cd)
		i32 65; uint32_t java_map_index (0x41)
	}, ; 64
	%struct.TypeMapModuleEntry {
		i32 33554638, ; uint32_t type_token_id (0x20000ce)
		i32 9; uint32_t java_map_index (0x9)
	}, ; 65
	%struct.TypeMapModuleEntry {
		i32 33554639, ; uint32_t type_token_id (0x20000cf)
		i32 73; uint32_t java_map_index (0x49)
	}, ; 66
	%struct.TypeMapModuleEntry {
		i32 33554645, ; uint32_t type_token_id (0x20000d5)
		i32 150; uint32_t java_map_index (0x96)
	}, ; 67
	%struct.TypeMapModuleEntry {
		i32 33554646, ; uint32_t type_token_id (0x20000d6)
		i32 20; uint32_t java_map_index (0x14)
	}, ; 68
	%struct.TypeMapModuleEntry {
		i32 33554648, ; uint32_t type_token_id (0x20000d8)
		i32 159; uint32_t java_map_index (0x9f)
	}, ; 69
	%struct.TypeMapModuleEntry {
		i32 33554649, ; uint32_t type_token_id (0x20000d9)
		i32 7; uint32_t java_map_index (0x7)
	}, ; 70
	%struct.TypeMapModuleEntry {
		i32 33554650, ; uint32_t type_token_id (0x20000da)
		i32 99; uint32_t java_map_index (0x63)
	}, ; 71
	%struct.TypeMapModuleEntry {
		i32 33554651, ; uint32_t type_token_id (0x20000db)
		i32 120; uint32_t java_map_index (0x78)
	}, ; 72
	%struct.TypeMapModuleEntry {
		i32 33554653, ; uint32_t type_token_id (0x20000dd)
		i32 133; uint32_t java_map_index (0x85)
	}, ; 73
	%struct.TypeMapModuleEntry {
		i32 33554654, ; uint32_t type_token_id (0x20000de)
		i32 128; uint32_t java_map_index (0x80)
	}, ; 74
	%struct.TypeMapModuleEntry {
		i32 33554657, ; uint32_t type_token_id (0x20000e1)
		i32 64; uint32_t java_map_index (0x40)
	}, ; 75
	%struct.TypeMapModuleEntry {
		i32 33554663, ; uint32_t type_token_id (0x20000e7)
		i32 155; uint32_t java_map_index (0x9b)
	}, ; 76
	%struct.TypeMapModuleEntry {
		i32 33554664, ; uint32_t type_token_id (0x20000e8)
		i32 88; uint32_t java_map_index (0x58)
	}, ; 77
	%struct.TypeMapModuleEntry {
		i32 33554665, ; uint32_t type_token_id (0x20000e9)
		i32 78; uint32_t java_map_index (0x4e)
	}, ; 78
	%struct.TypeMapModuleEntry {
		i32 33554667, ; uint32_t type_token_id (0x20000eb)
		i32 25; uint32_t java_map_index (0x19)
	}, ; 79
	%struct.TypeMapModuleEntry {
		i32 33554672, ; uint32_t type_token_id (0x20000f0)
		i32 26; uint32_t java_map_index (0x1a)
	}, ; 80
	%struct.TypeMapModuleEntry {
		i32 33554695, ; uint32_t type_token_id (0x2000107)
		i32 154; uint32_t java_map_index (0x9a)
	}, ; 81
	%struct.TypeMapModuleEntry {
		i32 33554697, ; uint32_t type_token_id (0x2000109)
		i32 96; uint32_t java_map_index (0x60)
	}, ; 82
	%struct.TypeMapModuleEntry {
		i32 33554699, ; uint32_t type_token_id (0x200010b)
		i32 170; uint32_t java_map_index (0xaa)
	}, ; 83
	%struct.TypeMapModuleEntry {
		i32 33554701, ; uint32_t type_token_id (0x200010d)
		i32 62; uint32_t java_map_index (0x3e)
	}, ; 84
	%struct.TypeMapModuleEntry {
		i32 33554710, ; uint32_t type_token_id (0x2000116)
		i32 97; uint32_t java_map_index (0x61)
	}, ; 85
	%struct.TypeMapModuleEntry {
		i32 33554712, ; uint32_t type_token_id (0x2000118)
		i32 153; uint32_t java_map_index (0x99)
	}, ; 86
	%struct.TypeMapModuleEntry {
		i32 33554713, ; uint32_t type_token_id (0x2000119)
		i32 14; uint32_t java_map_index (0xe)
	}, ; 87
	%struct.TypeMapModuleEntry {
		i32 33554714, ; uint32_t type_token_id (0x200011a)
		i32 11; uint32_t java_map_index (0xb)
	}, ; 88
	%struct.TypeMapModuleEntry {
		i32 33554727, ; uint32_t type_token_id (0x2000127)
		i32 127; uint32_t java_map_index (0x7f)
	}, ; 89
	%struct.TypeMapModuleEntry {
		i32 33554736, ; uint32_t type_token_id (0x2000130)
		i32 48; uint32_t java_map_index (0x30)
	}, ; 90
	%struct.TypeMapModuleEntry {
		i32 33554737, ; uint32_t type_token_id (0x2000131)
		i32 148; uint32_t java_map_index (0x94)
	}, ; 91
	%struct.TypeMapModuleEntry {
		i32 33554738, ; uint32_t type_token_id (0x2000132)
		i32 147; uint32_t java_map_index (0x93)
	}, ; 92
	%struct.TypeMapModuleEntry {
		i32 33554739, ; uint32_t type_token_id (0x2000133)
		i32 122; uint32_t java_map_index (0x7a)
	}, ; 93
	%struct.TypeMapModuleEntry {
		i32 33554743, ; uint32_t type_token_id (0x2000137)
		i32 101; uint32_t java_map_index (0x65)
	}, ; 94
	%struct.TypeMapModuleEntry {
		i32 33554745, ; uint32_t type_token_id (0x2000139)
		i32 71; uint32_t java_map_index (0x47)
	}, ; 95
	%struct.TypeMapModuleEntry {
		i32 33554746, ; uint32_t type_token_id (0x200013a)
		i32 151; uint32_t java_map_index (0x97)
	}, ; 96
	%struct.TypeMapModuleEntry {
		i32 33554749, ; uint32_t type_token_id (0x200013d)
		i32 6; uint32_t java_map_index (0x6)
	}, ; 97
	%struct.TypeMapModuleEntry {
		i32 33554750, ; uint32_t type_token_id (0x200013e)
		i32 34; uint32_t java_map_index (0x22)
	}, ; 98
	%struct.TypeMapModuleEntry {
		i32 33554752, ; uint32_t type_token_id (0x2000140)
		i32 27; uint32_t java_map_index (0x1b)
	}, ; 99
	%struct.TypeMapModuleEntry {
		i32 33554753, ; uint32_t type_token_id (0x2000141)
		i32 156; uint32_t java_map_index (0x9c)
	}, ; 100
	%struct.TypeMapModuleEntry {
		i32 33554755, ; uint32_t type_token_id (0x2000143)
		i32 166; uint32_t java_map_index (0xa6)
	}, ; 101
	%struct.TypeMapModuleEntry {
		i32 33554757, ; uint32_t type_token_id (0x2000145)
		i32 129; uint32_t java_map_index (0x81)
	}, ; 102
	%struct.TypeMapModuleEntry {
		i32 33554761, ; uint32_t type_token_id (0x2000149)
		i32 110; uint32_t java_map_index (0x6e)
	}, ; 103
	%struct.TypeMapModuleEntry {
		i32 33554763, ; uint32_t type_token_id (0x200014b)
		i32 103; uint32_t java_map_index (0x67)
	}, ; 104
	%struct.TypeMapModuleEntry {
		i32 33554766, ; uint32_t type_token_id (0x200014e)
		i32 160; uint32_t java_map_index (0xa0)
	}, ; 105
	%struct.TypeMapModuleEntry {
		i32 33554768, ; uint32_t type_token_id (0x2000150)
		i32 15; uint32_t java_map_index (0xf)
	}, ; 106
	%struct.TypeMapModuleEntry {
		i32 33554770, ; uint32_t type_token_id (0x2000152)
		i32 92; uint32_t java_map_index (0x5c)
	}, ; 107
	%struct.TypeMapModuleEntry {
		i32 33554771, ; uint32_t type_token_id (0x2000153)
		i32 10; uint32_t java_map_index (0xa)
	}, ; 108
	%struct.TypeMapModuleEntry {
		i32 33554773, ; uint32_t type_token_id (0x2000155)
		i32 79; uint32_t java_map_index (0x4f)
	}, ; 109
	%struct.TypeMapModuleEntry {
		i32 33554775, ; uint32_t type_token_id (0x2000157)
		i32 162; uint32_t java_map_index (0xa2)
	}, ; 110
	%struct.TypeMapModuleEntry {
		i32 33554776, ; uint32_t type_token_id (0x2000158)
		i32 24; uint32_t java_map_index (0x18)
	}, ; 111
	%struct.TypeMapModuleEntry {
		i32 33554777, ; uint32_t type_token_id (0x2000159)
		i32 98; uint32_t java_map_index (0x62)
	}, ; 112
	%struct.TypeMapModuleEntry {
		i32 33554779, ; uint32_t type_token_id (0x200015b)
		i32 123; uint32_t java_map_index (0x7b)
	}, ; 113
	%struct.TypeMapModuleEntry {
		i32 33554781, ; uint32_t type_token_id (0x200015d)
		i32 66; uint32_t java_map_index (0x42)
	}, ; 114
	%struct.TypeMapModuleEntry {
		i32 33554783, ; uint32_t type_token_id (0x200015f)
		i32 12; uint32_t java_map_index (0xc)
	}, ; 115
	%struct.TypeMapModuleEntry {
		i32 33554784, ; uint32_t type_token_id (0x2000160)
		i32 23; uint32_t java_map_index (0x17)
	}, ; 116
	%struct.TypeMapModuleEntry {
		i32 33554786, ; uint32_t type_token_id (0x2000162)
		i32 35; uint32_t java_map_index (0x23)
	}, ; 117
	%struct.TypeMapModuleEntry {
		i32 33554787, ; uint32_t type_token_id (0x2000163)
		i32 16; uint32_t java_map_index (0x10)
	}, ; 118
	%struct.TypeMapModuleEntry {
		i32 33554788, ; uint32_t type_token_id (0x2000164)
		i32 19; uint32_t java_map_index (0x13)
	}, ; 119
	%struct.TypeMapModuleEntry {
		i32 33554789, ; uint32_t type_token_id (0x2000165)
		i32 163; uint32_t java_map_index (0xa3)
	}, ; 120
	%struct.TypeMapModuleEntry {
		i32 33554790, ; uint32_t type_token_id (0x2000166)
		i32 37; uint32_t java_map_index (0x25)
	}, ; 121
	%struct.TypeMapModuleEntry {
		i32 33554792, ; uint32_t type_token_id (0x2000168)
		i32 146; uint32_t java_map_index (0x92)
	}, ; 122
	%struct.TypeMapModuleEntry {
		i32 33554793, ; uint32_t type_token_id (0x2000169)
		i32 109; uint32_t java_map_index (0x6d)
	}, ; 123
	%struct.TypeMapModuleEntry {
		i32 33554794, ; uint32_t type_token_id (0x200016a)
		i32 121; uint32_t java_map_index (0x79)
	}, ; 124
	%struct.TypeMapModuleEntry {
		i32 33554795, ; uint32_t type_token_id (0x200016b)
		i32 83; uint32_t java_map_index (0x53)
	}, ; 125
	%struct.TypeMapModuleEntry {
		i32 33554796, ; uint32_t type_token_id (0x200016c)
		i32 49; uint32_t java_map_index (0x31)
	}, ; 126
	%struct.TypeMapModuleEntry {
		i32 33554799, ; uint32_t type_token_id (0x200016f)
		i32 59; uint32_t java_map_index (0x3b)
	}, ; 127
	%struct.TypeMapModuleEntry {
		i32 33554800, ; uint32_t type_token_id (0x2000170)
		i32 13; uint32_t java_map_index (0xd)
	}, ; 128
	%struct.TypeMapModuleEntry {
		i32 33554801, ; uint32_t type_token_id (0x2000171)
		i32 22; uint32_t java_map_index (0x16)
	}, ; 129
	%struct.TypeMapModuleEntry {
		i32 33554803, ; uint32_t type_token_id (0x2000173)
		i32 60; uint32_t java_map_index (0x3c)
	}, ; 130
	%struct.TypeMapModuleEntry {
		i32 33554804, ; uint32_t type_token_id (0x2000174)
		i32 18; uint32_t java_map_index (0x12)
	}, ; 131
	%struct.TypeMapModuleEntry {
		i32 33554805, ; uint32_t type_token_id (0x2000175)
		i32 158; uint32_t java_map_index (0x9e)
	}, ; 132
	%struct.TypeMapModuleEntry {
		i32 33554807, ; uint32_t type_token_id (0x2000177)
		i32 32; uint32_t java_map_index (0x20)
	}, ; 133
	%struct.TypeMapModuleEntry {
		i32 33554808, ; uint32_t type_token_id (0x2000178)
		i32 75; uint32_t java_map_index (0x4b)
	}, ; 134
	%struct.TypeMapModuleEntry {
		i32 33554810, ; uint32_t type_token_id (0x200017a)
		i32 117; uint32_t java_map_index (0x75)
	}, ; 135
	%struct.TypeMapModuleEntry {
		i32 33554811, ; uint32_t type_token_id (0x200017b)
		i32 143; uint32_t java_map_index (0x8f)
	}, ; 136
	%struct.TypeMapModuleEntry {
		i32 33554813, ; uint32_t type_token_id (0x200017d)
		i32 74; uint32_t java_map_index (0x4a)
	}, ; 137
	%struct.TypeMapModuleEntry {
		i32 33554814, ; uint32_t type_token_id (0x200017e)
		i32 131; uint32_t java_map_index (0x83)
	}, ; 138
	%struct.TypeMapModuleEntry {
		i32 33554815, ; uint32_t type_token_id (0x200017f)
		i32 61; uint32_t java_map_index (0x3d)
	}, ; 139
	%struct.TypeMapModuleEntry {
		i32 33554816, ; uint32_t type_token_id (0x2000180)
		i32 42; uint32_t java_map_index (0x2a)
	}, ; 140
	%struct.TypeMapModuleEntry {
		i32 33554817, ; uint32_t type_token_id (0x2000181)
		i32 126; uint32_t java_map_index (0x7e)
	}, ; 141
	%struct.TypeMapModuleEntry {
		i32 33554818, ; uint32_t type_token_id (0x2000182)
		i32 161; uint32_t java_map_index (0xa1)
	}, ; 142
	%struct.TypeMapModuleEntry {
		i32 33554819, ; uint32_t type_token_id (0x2000183)
		i32 54; uint32_t java_map_index (0x36)
	}, ; 143
	%struct.TypeMapModuleEntry {
		i32 33554821, ; uint32_t type_token_id (0x2000185)
		i32 47; uint32_t java_map_index (0x2f)
	}, ; 144
	%struct.TypeMapModuleEntry {
		i32 33554822, ; uint32_t type_token_id (0x2000186)
		i32 8; uint32_t java_map_index (0x8)
	}, ; 145
	%struct.TypeMapModuleEntry {
		i32 33554823, ; uint32_t type_token_id (0x2000187)
		i32 169; uint32_t java_map_index (0xa9)
	}, ; 146
	%struct.TypeMapModuleEntry {
		i32 33554824, ; uint32_t type_token_id (0x2000188)
		i32 134; uint32_t java_map_index (0x86)
	}, ; 147
	%struct.TypeMapModuleEntry {
		i32 33554827, ; uint32_t type_token_id (0x200018b)
		i32 69; uint32_t java_map_index (0x45)
	}, ; 148
	%struct.TypeMapModuleEntry {
		i32 33554828, ; uint32_t type_token_id (0x200018c)
		i32 105; uint32_t java_map_index (0x69)
	}, ; 149
	%struct.TypeMapModuleEntry {
		i32 33554829, ; uint32_t type_token_id (0x200018d)
		i32 102; uint32_t java_map_index (0x66)
	}, ; 150
	%struct.TypeMapModuleEntry {
		i32 33554830, ; uint32_t type_token_id (0x200018e)
		i32 108; uint32_t java_map_index (0x6c)
	}, ; 151
	%struct.TypeMapModuleEntry {
		i32 33554831, ; uint32_t type_token_id (0x200018f)
		i32 72; uint32_t java_map_index (0x48)
	}, ; 152
	%struct.TypeMapModuleEntry {
		i32 33554833, ; uint32_t type_token_id (0x2000191)
		i32 87; uint32_t java_map_index (0x57)
	}, ; 153
	%struct.TypeMapModuleEntry {
		i32 33554834, ; uint32_t type_token_id (0x2000192)
		i32 86; uint32_t java_map_index (0x56)
	}, ; 154
	%struct.TypeMapModuleEntry {
		i32 33554835, ; uint32_t type_token_id (0x2000193)
		i32 106; uint32_t java_map_index (0x6a)
	}, ; 155
	%struct.TypeMapModuleEntry {
		i32 33554837, ; uint32_t type_token_id (0x2000195)
		i32 125; uint32_t java_map_index (0x7d)
	}, ; 156
	%struct.TypeMapModuleEntry {
		i32 33554838, ; uint32_t type_token_id (0x2000196)
		i32 118; uint32_t java_map_index (0x76)
	}, ; 157
	%struct.TypeMapModuleEntry {
		i32 33554839, ; uint32_t type_token_id (0x2000197)
		i32 84; uint32_t java_map_index (0x54)
	}, ; 158
	%struct.TypeMapModuleEntry {
		i32 33554840, ; uint32_t type_token_id (0x2000198)
		i32 90; uint32_t java_map_index (0x5a)
	}, ; 159
	%struct.TypeMapModuleEntry {
		i32 33554841, ; uint32_t type_token_id (0x2000199)
		i32 137; uint32_t java_map_index (0x89)
	}, ; 160
	%struct.TypeMapModuleEntry {
		i32 33554842, ; uint32_t type_token_id (0x200019a)
		i32 0; uint32_t java_map_index (0x0)
	}, ; 161
	%struct.TypeMapModuleEntry {
		i32 33554844, ; uint32_t type_token_id (0x200019c)
		i32 82; uint32_t java_map_index (0x52)
	}, ; 162
	%struct.TypeMapModuleEntry {
		i32 33554845, ; uint32_t type_token_id (0x200019d)
		i32 95; uint32_t java_map_index (0x5f)
	}, ; 163
	%struct.TypeMapModuleEntry {
		i32 33554846, ; uint32_t type_token_id (0x200019e)
		i32 136; uint32_t java_map_index (0x88)
	}, ; 164
	%struct.TypeMapModuleEntry {
		i32 33554847, ; uint32_t type_token_id (0x200019f)
		i32 89; uint32_t java_map_index (0x59)
	}, ; 165
	%struct.TypeMapModuleEntry {
		i32 33554863, ; uint32_t type_token_id (0x20001af)
		i32 113; uint32_t java_map_index (0x71)
	} ; 166
], align 16

@module0_managed_to_java_duplicates = internal dso_local constant [63 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554534, ; uint32_t type_token_id (0x2000066)
		i32 139; uint32_t java_map_index (0x8b)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554538, ; uint32_t type_token_id (0x200006a)
		i32 38; uint32_t java_map_index (0x26)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554540, ; uint32_t type_token_id (0x200006c)
		i32 53; uint32_t java_map_index (0x35)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554543, ; uint32_t type_token_id (0x200006f)
		i32 46; uint32_t java_map_index (0x2e)
	}, ; 3
	%struct.TypeMapModuleEntry {
		i32 33554545, ; uint32_t type_token_id (0x2000071)
		i32 5; uint32_t java_map_index (0x5)
	}, ; 4
	%struct.TypeMapModuleEntry {
		i32 33554547, ; uint32_t type_token_id (0x2000073)
		i32 138; uint32_t java_map_index (0x8a)
	}, ; 5
	%struct.TypeMapModuleEntry {
		i32 33554549, ; uint32_t type_token_id (0x2000075)
		i32 77; uint32_t java_map_index (0x4d)
	}, ; 6
	%struct.TypeMapModuleEntry {
		i32 33554551, ; uint32_t type_token_id (0x2000077)
		i32 56; uint32_t java_map_index (0x38)
	}, ; 7
	%struct.TypeMapModuleEntry {
		i32 33554553, ; uint32_t type_token_id (0x2000079)
		i32 144; uint32_t java_map_index (0x90)
	}, ; 8
	%struct.TypeMapModuleEntry {
		i32 33554555, ; uint32_t type_token_id (0x200007b)
		i32 145; uint32_t java_map_index (0x91)
	}, ; 9
	%struct.TypeMapModuleEntry {
		i32 33554559, ; uint32_t type_token_id (0x200007f)
		i32 167; uint32_t java_map_index (0xa7)
	}, ; 10
	%struct.TypeMapModuleEntry {
		i32 33554563, ; uint32_t type_token_id (0x2000083)
		i32 107; uint32_t java_map_index (0x6b)
	}, ; 11
	%struct.TypeMapModuleEntry {
		i32 33554565, ; uint32_t type_token_id (0x2000085)
		i32 33; uint32_t java_map_index (0x21)
	}, ; 12
	%struct.TypeMapModuleEntry {
		i32 33554568, ; uint32_t type_token_id (0x2000088)
		i32 168; uint32_t java_map_index (0xa8)
	}, ; 13
	%struct.TypeMapModuleEntry {
		i32 33554574, ; uint32_t type_token_id (0x200008e)
		i32 52; uint32_t java_map_index (0x34)
	}, ; 14
	%struct.TypeMapModuleEntry {
		i32 33554576, ; uint32_t type_token_id (0x2000090)
		i32 36; uint32_t java_map_index (0x24)
	}, ; 15
	%struct.TypeMapModuleEntry {
		i32 33554584, ; uint32_t type_token_id (0x2000098)
		i32 135; uint32_t java_map_index (0x87)
	}, ; 16
	%struct.TypeMapModuleEntry {
		i32 33554591, ; uint32_t type_token_id (0x200009f)
		i32 33; uint32_t java_map_index (0x21)
	}, ; 17
	%struct.TypeMapModuleEntry {
		i32 33554592, ; uint32_t type_token_id (0x20000a0)
		i32 40; uint32_t java_map_index (0x28)
	}, ; 18
	%struct.TypeMapModuleEntry {
		i32 33554594, ; uint32_t type_token_id (0x20000a2)
		i32 76; uint32_t java_map_index (0x4c)
	}, ; 19
	%struct.TypeMapModuleEntry {
		i32 33554596, ; uint32_t type_token_id (0x20000a4)
		i32 4; uint32_t java_map_index (0x4)
	}, ; 20
	%struct.TypeMapModuleEntry {
		i32 33554598, ; uint32_t type_token_id (0x20000a6)
		i32 142; uint32_t java_map_index (0x8e)
	}, ; 21
	%struct.TypeMapModuleEntry {
		i32 33554603, ; uint32_t type_token_id (0x20000ab)
		i32 45; uint32_t java_map_index (0x2d)
	}, ; 22
	%struct.TypeMapModuleEntry {
		i32 33554608, ; uint32_t type_token_id (0x20000b0)
		i32 119; uint32_t java_map_index (0x77)
	}, ; 23
	%struct.TypeMapModuleEntry {
		i32 33554616, ; uint32_t type_token_id (0x20000b8)
		i32 80; uint32_t java_map_index (0x50)
	}, ; 24
	%struct.TypeMapModuleEntry {
		i32 33554618, ; uint32_t type_token_id (0x20000ba)
		i32 70; uint32_t java_map_index (0x46)
	}, ; 25
	%struct.TypeMapModuleEntry {
		i32 33554620, ; uint32_t type_token_id (0x20000bc)
		i32 41; uint32_t java_map_index (0x29)
	}, ; 26
	%struct.TypeMapModuleEntry {
		i32 33554626, ; uint32_t type_token_id (0x20000c2)
		i32 43; uint32_t java_map_index (0x2b)
	}, ; 27
	%struct.TypeMapModuleEntry {
		i32 33554628, ; uint32_t type_token_id (0x20000c4)
		i32 91; uint32_t java_map_index (0x5b)
	}, ; 28
	%struct.TypeMapModuleEntry {
		i32 33554647, ; uint32_t type_token_id (0x20000d7)
		i32 20; uint32_t java_map_index (0x14)
	}, ; 29
	%struct.TypeMapModuleEntry {
		i32 33554652, ; uint32_t type_token_id (0x20000dc)
		i32 120; uint32_t java_map_index (0x78)
	}, ; 30
	%struct.TypeMapModuleEntry {
		i32 33554655, ; uint32_t type_token_id (0x20000df)
		i32 128; uint32_t java_map_index (0x80)
	}, ; 31
	%struct.TypeMapModuleEntry {
		i32 33554666, ; uint32_t type_token_id (0x20000ea)
		i32 155; uint32_t java_map_index (0x9b)
	}, ; 32
	%struct.TypeMapModuleEntry {
		i32 33554668, ; uint32_t type_token_id (0x20000ec)
		i32 25; uint32_t java_map_index (0x19)
	}, ; 33
	%struct.TypeMapModuleEntry {
		i32 33554700, ; uint32_t type_token_id (0x200010c)
		i32 170; uint32_t java_map_index (0xaa)
	}, ; 34
	%struct.TypeMapModuleEntry {
		i32 33554706, ; uint32_t type_token_id (0x2000112)
		i32 62; uint32_t java_map_index (0x3e)
	}, ; 35
	%struct.TypeMapModuleEntry {
		i32 33554711, ; uint32_t type_token_id (0x2000117)
		i32 97; uint32_t java_map_index (0x61)
	}, ; 36
	%struct.TypeMapModuleEntry {
		i32 33554715, ; uint32_t type_token_id (0x200011b)
		i32 11; uint32_t java_map_index (0xb)
	}, ; 37
	%struct.TypeMapModuleEntry {
		i32 33554744, ; uint32_t type_token_id (0x2000138)
		i32 101; uint32_t java_map_index (0x65)
	}, ; 38
	%struct.TypeMapModuleEntry {
		i32 33554747, ; uint32_t type_token_id (0x200013b)
		i32 151; uint32_t java_map_index (0x97)
	}, ; 39
	%struct.TypeMapModuleEntry {
		i32 33554751, ; uint32_t type_token_id (0x200013f)
		i32 34; uint32_t java_map_index (0x22)
	}, ; 40
	%struct.TypeMapModuleEntry {
		i32 33554754, ; uint32_t type_token_id (0x2000142)
		i32 156; uint32_t java_map_index (0x9c)
	}, ; 41
	%struct.TypeMapModuleEntry {
		i32 33554756, ; uint32_t type_token_id (0x2000144)
		i32 166; uint32_t java_map_index (0xa6)
	}, ; 42
	%struct.TypeMapModuleEntry {
		i32 33554758, ; uint32_t type_token_id (0x2000146)
		i32 129; uint32_t java_map_index (0x81)
	}, ; 43
	%struct.TypeMapModuleEntry {
		i32 33554762, ; uint32_t type_token_id (0x200014a)
		i32 110; uint32_t java_map_index (0x6e)
	}, ; 44
	%struct.TypeMapModuleEntry {
		i32 33554767, ; uint32_t type_token_id (0x200014f)
		i32 160; uint32_t java_map_index (0xa0)
	}, ; 45
	%struct.TypeMapModuleEntry {
		i32 33554769, ; uint32_t type_token_id (0x2000151)
		i32 15; uint32_t java_map_index (0xf)
	}, ; 46
	%struct.TypeMapModuleEntry {
		i32 33554772, ; uint32_t type_token_id (0x2000154)
		i32 10; uint32_t java_map_index (0xa)
	}, ; 47
	%struct.TypeMapModuleEntry {
		i32 33554774, ; uint32_t type_token_id (0x2000156)
		i32 79; uint32_t java_map_index (0x4f)
	}, ; 48
	%struct.TypeMapModuleEntry {
		i32 33554778, ; uint32_t type_token_id (0x200015a)
		i32 98; uint32_t java_map_index (0x62)
	}, ; 49
	%struct.TypeMapModuleEntry {
		i32 33554780, ; uint32_t type_token_id (0x200015c)
		i32 123; uint32_t java_map_index (0x7b)
	}, ; 50
	%struct.TypeMapModuleEntry {
		i32 33554782, ; uint32_t type_token_id (0x200015e)
		i32 66; uint32_t java_map_index (0x42)
	}, ; 51
	%struct.TypeMapModuleEntry {
		i32 33554785, ; uint32_t type_token_id (0x2000161)
		i32 23; uint32_t java_map_index (0x17)
	}, ; 52
	%struct.TypeMapModuleEntry {
		i32 33554791, ; uint32_t type_token_id (0x2000167)
		i32 37; uint32_t java_map_index (0x25)
	}, ; 53
	%struct.TypeMapModuleEntry {
		i32 33554797, ; uint32_t type_token_id (0x200016d)
		i32 49; uint32_t java_map_index (0x31)
	}, ; 54
	%struct.TypeMapModuleEntry {
		i32 33554802, ; uint32_t type_token_id (0x2000172)
		i32 22; uint32_t java_map_index (0x16)
	}, ; 55
	%struct.TypeMapModuleEntry {
		i32 33554806, ; uint32_t type_token_id (0x2000176)
		i32 158; uint32_t java_map_index (0x9e)
	}, ; 56
	%struct.TypeMapModuleEntry {
		i32 33554809, ; uint32_t type_token_id (0x2000179)
		i32 75; uint32_t java_map_index (0x4b)
	}, ; 57
	%struct.TypeMapModuleEntry {
		i32 33554812, ; uint32_t type_token_id (0x200017c)
		i32 143; uint32_t java_map_index (0x8f)
	}, ; 58
	%struct.TypeMapModuleEntry {
		i32 33554820, ; uint32_t type_token_id (0x2000184)
		i32 54; uint32_t java_map_index (0x36)
	}, ; 59
	%struct.TypeMapModuleEntry {
		i32 33554825, ; uint32_t type_token_id (0x2000189)
		i32 134; uint32_t java_map_index (0x86)
	}, ; 60
	%struct.TypeMapModuleEntry {
		i32 33554832, ; uint32_t type_token_id (0x2000190)
		i32 72; uint32_t java_map_index (0x48)
	}, ; 61
	%struct.TypeMapModuleEntry {
		i32 33554836, ; uint32_t type_token_id (0x2000194)
		i32 106; uint32_t java_map_index (0x6a)
	} ; 62
], align 16

@module1_managed_to_java = internal dso_local constant [4 x %struct.TypeMapModuleEntry] [
	%struct.TypeMapModuleEntry {
		i32 33554435, ; uint32_t type_token_id (0x2000003)
		i32 81; uint32_t java_map_index (0x51)
	}, ; 0
	%struct.TypeMapModuleEntry {
		i32 33554437, ; uint32_t type_token_id (0x2000005)
		i32 30; uint32_t java_map_index (0x1e)
	}, ; 1
	%struct.TypeMapModuleEntry {
		i32 33554438, ; uint32_t type_token_id (0x2000006)
		i32 68; uint32_t java_map_index (0x44)
	}, ; 2
	%struct.TypeMapModuleEntry {
		i32 33554439, ; uint32_t type_token_id (0x2000007)
		i32 164; uint32_t java_map_index (0xa4)
	} ; 3
], align 16

; Java to managed map
@map_java = dso_local local_unnamed_addr constant [171 x %struct.TypeMapJava] [
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554842, ; uint32_t type_token_id (0x200019a)
		i32 161; uint32_t java_name_index (0xa1)
	}, ; 0
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554569, ; uint32_t type_token_id (0x2000089)
		i32 21; uint32_t java_name_index (0x15)
	}, ; 1
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554613, ; uint32_t type_token_id (0x20000b5)
		i32 48; uint32_t java_name_index (0x30)
	}, ; 2
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554582, ; uint32_t type_token_id (0x2000096)
		i32 32; uint32_t java_name_index (0x20)
	}, ; 3
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 36; uint32_t java_name_index (0x24)
	}, ; 4
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554544, ; uint32_t type_token_id (0x2000070)
		i32 6; uint32_t java_name_index (0x6)
	}, ; 5
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554749, ; uint32_t type_token_id (0x200013d)
		i32 97; uint32_t java_name_index (0x61)
	}, ; 6
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554649, ; uint32_t type_token_id (0x20000d9)
		i32 70; uint32_t java_name_index (0x46)
	}, ; 7
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554822, ; uint32_t type_token_id (0x2000186)
		i32 145; uint32_t java_name_index (0x91)
	}, ; 8
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554638, ; uint32_t type_token_id (0x20000ce)
		i32 65; uint32_t java_name_index (0x41)
	}, ; 9
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 108; uint32_t java_name_index (0x6c)
	}, ; 10
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554714, ; uint32_t type_token_id (0x200011a)
		i32 88; uint32_t java_name_index (0x58)
	}, ; 11
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554783, ; uint32_t type_token_id (0x200015f)
		i32 115; uint32_t java_name_index (0x73)
	}, ; 12
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554800, ; uint32_t type_token_id (0x2000170)
		i32 128; uint32_t java_name_index (0x80)
	}, ; 13
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554713, ; uint32_t type_token_id (0x2000119)
		i32 87; uint32_t java_name_index (0x57)
	}, ; 14
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 106; uint32_t java_name_index (0x6a)
	}, ; 15
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554787, ; uint32_t type_token_id (0x2000163)
		i32 118; uint32_t java_name_index (0x76)
	}, ; 16
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554610, ; uint32_t type_token_id (0x20000b2)
		i32 45; uint32_t java_name_index (0x2d)
	}, ; 17
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554804, ; uint32_t type_token_id (0x2000174)
		i32 131; uint32_t java_name_index (0x83)
	}, ; 18
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554788, ; uint32_t type_token_id (0x2000164)
		i32 119; uint32_t java_name_index (0x77)
	}, ; 19
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554646, ; uint32_t type_token_id (0x20000d6)
		i32 68; uint32_t java_name_index (0x44)
	}, ; 20
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554535, ; uint32_t type_token_id (0x2000067)
		i32 1; uint32_t java_name_index (0x1)
	}, ; 21
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554801, ; uint32_t type_token_id (0x2000171)
		i32 129; uint32_t java_name_index (0x81)
	}, ; 22
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554784, ; uint32_t type_token_id (0x2000160)
		i32 116; uint32_t java_name_index (0x74)
	}, ; 23
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554776, ; uint32_t type_token_id (0x2000158)
		i32 111; uint32_t java_name_index (0x6f)
	}, ; 24
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554667, ; uint32_t type_token_id (0x20000eb)
		i32 79; uint32_t java_name_index (0x4f)
	}, ; 25
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554672, ; uint32_t type_token_id (0x20000f0)
		i32 80; uint32_t java_name_index (0x50)
	}, ; 26
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554752, ; uint32_t type_token_id (0x2000140)
		i32 99; uint32_t java_name_index (0x63)
	}, ; 27
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554611, ; uint32_t type_token_id (0x20000b3)
		i32 46; uint32_t java_name_index (0x2e)
	}, ; 28
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554580, ; uint32_t type_token_id (0x2000094)
		i32 30; uint32_t java_name_index (0x1e)
	}, ; 29
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554437, ; uint32_t type_token_id (0x2000005)
		i32 168; uint32_t java_name_index (0xa8)
	}, ; 30
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554634, ; uint32_t type_token_id (0x20000ca)
		i32 61; uint32_t java_name_index (0x3d)
	}, ; 31
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554807, ; uint32_t type_token_id (0x2000177)
		i32 133; uint32_t java_name_index (0x85)
	}, ; 32
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554564, ; uint32_t type_token_id (0x2000084)
		i32 18; uint32_t java_name_index (0x12)
	}, ; 33
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 98; uint32_t java_name_index (0x62)
	}, ; 34
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554786, ; uint32_t type_token_id (0x2000162)
		i32 117; uint32_t java_name_index (0x75)
	}, ; 35
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 26; uint32_t java_name_index (0x1a)
	}, ; 36
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554790, ; uint32_t type_token_id (0x2000166)
		i32 121; uint32_t java_name_index (0x79)
	}, ; 37
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554537, ; uint32_t type_token_id (0x2000069)
		i32 2; uint32_t java_name_index (0x2)
	}, ; 38
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554600, ; uint32_t type_token_id (0x20000a8)
		i32 38; uint32_t java_name_index (0x26)
	}, ; 39
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554566, ; uint32_t type_token_id (0x2000086)
		i32 19; uint32_t java_name_index (0x13)
	}, ; 40
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 52; uint32_t java_name_index (0x34)
	}, ; 41
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554816, ; uint32_t type_token_id (0x2000180)
		i32 140; uint32_t java_name_index (0x8c)
	}, ; 42
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554625, ; uint32_t type_token_id (0x20000c1)
		i32 55; uint32_t java_name_index (0x37)
	}, ; 43
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554560, ; uint32_t type_token_id (0x2000080)
		i32 15; uint32_t java_name_index (0xf)
	}, ; 44
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554602, ; uint32_t type_token_id (0x20000aa)
		i32 40; uint32_t java_name_index (0x28)
	}, ; 45
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554542, ; uint32_t type_token_id (0x200006e)
		i32 5; uint32_t java_name_index (0x5)
	}, ; 46
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554821, ; uint32_t type_token_id (0x2000185)
		i32 144; uint32_t java_name_index (0x90)
	}, ; 47
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554736, ; uint32_t type_token_id (0x2000130)
		i32 90; uint32_t java_name_index (0x5a)
	}, ; 48
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554796, ; uint32_t type_token_id (0x200016c)
		i32 126; uint32_t java_name_index (0x7e)
	}, ; 49
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554578, ; uint32_t type_token_id (0x2000092)
		i32 28; uint32_t java_name_index (0x1c)
	}, ; 50
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554571, ; uint32_t type_token_id (0x200008b)
		i32 23; uint32_t java_name_index (0x17)
	}, ; 51
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 25; uint32_t java_name_index (0x19)
	}, ; 52
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554539, ; uint32_t type_token_id (0x200006b)
		i32 3; uint32_t java_name_index (0x3)
	}, ; 53
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554819, ; uint32_t type_token_id (0x2000183)
		i32 143; uint32_t java_name_index (0x8f)
	}, ; 54
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554577, ; uint32_t type_token_id (0x2000091)
		i32 27; uint32_t java_name_index (0x1b)
	}, ; 55
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 9; uint32_t java_name_index (0x9)
	}, ; 56
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554586, ; uint32_t type_token_id (0x200009a)
		i32 34; uint32_t java_name_index (0x22)
	}, ; 57
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554612, ; uint32_t type_token_id (0x20000b4)
		i32 47; uint32_t java_name_index (0x2f)
	}, ; 58
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554799, ; uint32_t type_token_id (0x200016f)
		i32 127; uint32_t java_name_index (0x7f)
	}, ; 59
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554803, ; uint32_t type_token_id (0x2000173)
		i32 130; uint32_t java_name_index (0x82)
	}, ; 60
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554815, ; uint32_t type_token_id (0x200017f)
		i32 139; uint32_t java_name_index (0x8b)
	}, ; 61
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554701, ; uint32_t type_token_id (0x200010d)
		i32 84; uint32_t java_name_index (0x54)
	}, ; 62
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554579, ; uint32_t type_token_id (0x2000093)
		i32 29; uint32_t java_name_index (0x1d)
	}, ; 63
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554657, ; uint32_t type_token_id (0x20000e1)
		i32 75; uint32_t java_name_index (0x4b)
	}, ; 64
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554637, ; uint32_t type_token_id (0x20000cd)
		i32 64; uint32_t java_name_index (0x40)
	}, ; 65
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554781, ; uint32_t type_token_id (0x200015d)
		i32 114; uint32_t java_name_index (0x72)
	}, ; 66
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554636, ; uint32_t type_token_id (0x20000cc)
		i32 63; uint32_t java_name_index (0x3f)
	}, ; 67
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554438, ; uint32_t type_token_id (0x2000006)
		i32 169; uint32_t java_name_index (0xa9)
	}, ; 68
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554827, ; uint32_t type_token_id (0x200018b)
		i32 148; uint32_t java_name_index (0x94)
	}, ; 69
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 51; uint32_t java_name_index (0x33)
	}, ; 70
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554745, ; uint32_t type_token_id (0x2000139)
		i32 95; uint32_t java_name_index (0x5f)
	}, ; 71
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 152; uint32_t java_name_index (0x98)
	}, ; 72
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554639, ; uint32_t type_token_id (0x20000cf)
		i32 66; uint32_t java_name_index (0x42)
	}, ; 73
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554813, ; uint32_t type_token_id (0x200017d)
		i32 137; uint32_t java_name_index (0x89)
	}, ; 74
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554808, ; uint32_t type_token_id (0x2000178)
		i32 134; uint32_t java_name_index (0x86)
	}, ; 75
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554593, ; uint32_t type_token_id (0x20000a1)
		i32 35; uint32_t java_name_index (0x23)
	}, ; 76
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 8; uint32_t java_name_index (0x8)
	}, ; 77
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554665, ; uint32_t type_token_id (0x20000e9)
		i32 78; uint32_t java_name_index (0x4e)
	}, ; 78
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 109; uint32_t java_name_index (0x6d)
	}, ; 79
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 50; uint32_t java_name_index (0x32)
	}, ; 80
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554435, ; uint32_t type_token_id (0x2000003)
		i32 167; uint32_t java_name_index (0xa7)
	}, ; 81
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554844, ; uint32_t type_token_id (0x200019c)
		i32 162; uint32_t java_name_index (0xa2)
	}, ; 82
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554795, ; uint32_t type_token_id (0x200016b)
		i32 125; uint32_t java_name_index (0x7d)
	}, ; 83
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554839, ; uint32_t type_token_id (0x2000197)
		i32 158; uint32_t java_name_index (0x9e)
	}, ; 84
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554630, ; uint32_t type_token_id (0x20000c6)
		i32 57; uint32_t java_name_index (0x39)
	}, ; 85
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554834, ; uint32_t type_token_id (0x2000192)
		i32 154; uint32_t java_name_index (0x9a)
	}, ; 86
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554833, ; uint32_t type_token_id (0x2000191)
		i32 153; uint32_t java_name_index (0x99)
	}, ; 87
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554664, ; uint32_t type_token_id (0x20000e8)
		i32 77; uint32_t java_name_index (0x4d)
	}, ; 88
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554847, ; uint32_t type_token_id (0x200019f)
		i32 165; uint32_t java_name_index (0xa5)
	}, ; 89
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554840, ; uint32_t type_token_id (0x2000198)
		i32 159; uint32_t java_name_index (0x9f)
	}, ; 90
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554627, ; uint32_t type_token_id (0x20000c3)
		i32 56; uint32_t java_name_index (0x38)
	}, ; 91
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554770, ; uint32_t type_token_id (0x2000152)
		i32 107; uint32_t java_name_index (0x6b)
	}, ; 92
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554614, ; uint32_t type_token_id (0x20000b6)
		i32 49; uint32_t java_name_index (0x31)
	}, ; 93
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554557, ; uint32_t type_token_id (0x200007d)
		i32 13; uint32_t java_name_index (0xd)
	}, ; 94
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554845, ; uint32_t type_token_id (0x200019d)
		i32 163; uint32_t java_name_index (0xa3)
	}, ; 95
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 82; uint32_t java_name_index (0x52)
	}, ; 96
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554710, ; uint32_t type_token_id (0x2000116)
		i32 85; uint32_t java_name_index (0x55)
	}, ; 97
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554777, ; uint32_t type_token_id (0x2000159)
		i32 112; uint32_t java_name_index (0x70)
	}, ; 98
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554650, ; uint32_t type_token_id (0x20000da)
		i32 71; uint32_t java_name_index (0x47)
	}, ; 99
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554570, ; uint32_t type_token_id (0x200008a)
		i32 22; uint32_t java_name_index (0x16)
	}, ; 100
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554743, ; uint32_t type_token_id (0x2000137)
		i32 94; uint32_t java_name_index (0x5e)
	}, ; 101
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554829, ; uint32_t type_token_id (0x200018d)
		i32 150; uint32_t java_name_index (0x96)
	}, ; 102
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554763, ; uint32_t type_token_id (0x200014b)
		i32 104; uint32_t java_name_index (0x68)
	}, ; 103
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554621, ; uint32_t type_token_id (0x20000bd)
		i32 53; uint32_t java_name_index (0x35)
	}, ; 104
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554828, ; uint32_t type_token_id (0x200018c)
		i32 149; uint32_t java_name_index (0x95)
	}, ; 105
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554835, ; uint32_t type_token_id (0x2000193)
		i32 155; uint32_t java_name_index (0x9b)
	}, ; 106
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554562, ; uint32_t type_token_id (0x2000082)
		i32 17; uint32_t java_name_index (0x11)
	}, ; 107
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554830, ; uint32_t type_token_id (0x200018e)
		i32 151; uint32_t java_name_index (0x97)
	}, ; 108
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554793, ; uint32_t type_token_id (0x2000169)
		i32 123; uint32_t java_name_index (0x7b)
	}, ; 109
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 103; uint32_t java_name_index (0x67)
	}, ; 110
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554632, ; uint32_t type_token_id (0x20000c8)
		i32 59; uint32_t java_name_index (0x3b)
	}, ; 111
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554635, ; uint32_t type_token_id (0x20000cb)
		i32 62; uint32_t java_name_index (0x3e)
	}, ; 112
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554863, ; uint32_t type_token_id (0x20001af)
		i32 166; uint32_t java_name_index (0xa6)
	}, ; 113
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554631, ; uint32_t type_token_id (0x20000c7)
		i32 58; uint32_t java_name_index (0x3a)
	}, ; 114
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554541, ; uint32_t type_token_id (0x200006d)
		i32 4; uint32_t java_name_index (0x4)
	}, ; 115
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554606, ; uint32_t type_token_id (0x20000ae)
		i32 43; uint32_t java_name_index (0x2b)
	}, ; 116
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554810, ; uint32_t type_token_id (0x200017a)
		i32 135; uint32_t java_name_index (0x87)
	}, ; 117
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554838, ; uint32_t type_token_id (0x2000196)
		i32 157; uint32_t java_name_index (0x9d)
	}, ; 118
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 44; uint32_t java_name_index (0x2c)
	}, ; 119
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 72; uint32_t java_name_index (0x48)
	}, ; 120
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554794, ; uint32_t type_token_id (0x200016a)
		i32 124; uint32_t java_name_index (0x7c)
	}, ; 121
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554739, ; uint32_t type_token_id (0x2000133)
		i32 93; uint32_t java_name_index (0x5d)
	}, ; 122
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554779, ; uint32_t type_token_id (0x200015b)
		i32 113; uint32_t java_name_index (0x71)
	}, ; 123
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554556, ; uint32_t type_token_id (0x200007c)
		i32 12; uint32_t java_name_index (0xc)
	}, ; 124
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554837, ; uint32_t type_token_id (0x2000195)
		i32 156; uint32_t java_name_index (0x9c)
	}, ; 125
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554817, ; uint32_t type_token_id (0x2000181)
		i32 141; uint32_t java_name_index (0x8d)
	}, ; 126
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554727, ; uint32_t type_token_id (0x2000127)
		i32 89; uint32_t java_name_index (0x59)
	}, ; 127
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 74; uint32_t java_name_index (0x4a)
	}, ; 128
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 102; uint32_t java_name_index (0x66)
	}, ; 129
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554622, ; uint32_t type_token_id (0x20000be)
		i32 54; uint32_t java_name_index (0x36)
	}, ; 130
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554814, ; uint32_t type_token_id (0x200017e)
		i32 138; uint32_t java_name_index (0x8a)
	}, ; 131
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554601, ; uint32_t type_token_id (0x20000a9)
		i32 39; uint32_t java_name_index (0x27)
	}, ; 132
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554653, ; uint32_t type_token_id (0x20000dd)
		i32 73; uint32_t java_name_index (0x49)
	}, ; 133
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 147; uint32_t java_name_index (0x93)
	}, ; 134
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 33; uint32_t java_name_index (0x21)
	}, ; 135
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554846, ; uint32_t type_token_id (0x200019e)
		i32 164; uint32_t java_name_index (0xa4)
	}, ; 136
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554841, ; uint32_t type_token_id (0x2000199)
		i32 160; uint32_t java_name_index (0xa0)
	}, ; 137
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 7; uint32_t java_name_index (0x7)
	}, ; 138
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 0; uint32_t java_name_index (0x0)
	}, ; 139
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554581, ; uint32_t type_token_id (0x2000095)
		i32 31; uint32_t java_name_index (0x1f)
	}, ; 140
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554561, ; uint32_t type_token_id (0x2000081)
		i32 16; uint32_t java_name_index (0x10)
	}, ; 141
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 37; uint32_t java_name_index (0x25)
	}, ; 142
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554811, ; uint32_t type_token_id (0x200017b)
		i32 136; uint32_t java_name_index (0x88)
	}, ; 143
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 10; uint32_t java_name_index (0xa)
	}, ; 144
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 11; uint32_t java_name_index (0xb)
	}, ; 145
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554792, ; uint32_t type_token_id (0x2000168)
		i32 122; uint32_t java_name_index (0x7a)
	}, ; 146
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554738, ; uint32_t type_token_id (0x2000132)
		i32 92; uint32_t java_name_index (0x5c)
	}, ; 147
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554737, ; uint32_t type_token_id (0x2000131)
		i32 91; uint32_t java_name_index (0x5b)
	}, ; 148
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554605, ; uint32_t type_token_id (0x20000ad)
		i32 42; uint32_t java_name_index (0x2a)
	}, ; 149
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554645, ; uint32_t type_token_id (0x20000d5)
		i32 67; uint32_t java_name_index (0x43)
	}, ; 150
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 96; uint32_t java_name_index (0x60)
	}, ; 151
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554633, ; uint32_t type_token_id (0x20000c9)
		i32 60; uint32_t java_name_index (0x3c)
	}, ; 152
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554712, ; uint32_t type_token_id (0x2000118)
		i32 86; uint32_t java_name_index (0x56)
	}, ; 153
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554695, ; uint32_t type_token_id (0x2000107)
		i32 81; uint32_t java_name_index (0x51)
	}, ; 154
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554663, ; uint32_t type_token_id (0x20000e7)
		i32 76; uint32_t java_name_index (0x4c)
	}, ; 155
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 100; uint32_t java_name_index (0x64)
	}, ; 156
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554572, ; uint32_t type_token_id (0x200008c)
		i32 24; uint32_t java_name_index (0x18)
	}, ; 157
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554805, ; uint32_t type_token_id (0x2000175)
		i32 132; uint32_t java_name_index (0x84)
	}, ; 158
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554648, ; uint32_t type_token_id (0x20000d8)
		i32 69; uint32_t java_name_index (0x45)
	}, ; 159
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 105; uint32_t java_name_index (0x69)
	}, ; 160
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554818, ; uint32_t type_token_id (0x2000182)
		i32 142; uint32_t java_name_index (0x8e)
	}, ; 161
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554775, ; uint32_t type_token_id (0x2000157)
		i32 110; uint32_t java_name_index (0x6e)
	}, ; 162
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554789, ; uint32_t type_token_id (0x2000165)
		i32 120; uint32_t java_name_index (0x78)
	}, ; 163
	%struct.TypeMapJava {
		i32 1, ; uint32_t module_index (0x1)
		i32 33554439, ; uint32_t type_token_id (0x2000007)
		i32 170; uint32_t java_name_index (0xaa)
	}, ; 164
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554604, ; uint32_t type_token_id (0x20000ac)
		i32 41; uint32_t java_name_index (0x29)
	}, ; 165
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 0, ; uint32_t type_token_id (0x0)
		i32 101; uint32_t java_name_index (0x65)
	}, ; 166
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554558, ; uint32_t type_token_id (0x200007e)
		i32 14; uint32_t java_name_index (0xe)
	}, ; 167
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554567, ; uint32_t type_token_id (0x2000087)
		i32 20; uint32_t java_name_index (0x14)
	}, ; 168
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554823, ; uint32_t type_token_id (0x2000187)
		i32 146; uint32_t java_name_index (0x92)
	}, ; 169
	%struct.TypeMapJava {
		i32 0, ; uint32_t module_index (0x0)
		i32 33554699, ; uint32_t type_token_id (0x200010b)
		i32 83; uint32_t java_name_index (0x53)
	} ; 170
], align 16

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
], align 16

; Strings
@.str.0 = private unnamed_addr constant [29 x i8] c"org/xmlpull/v1/XmlPullParser\00", align 16
@.str.1 = private unnamed_addr constant [38 x i8] c"org/xmlpull/v1/XmlPullParserException\00", align 16
@.str.2 = private unnamed_addr constant [32 x i8] c"javax/security/cert/Certificate\00", align 16
@.str.3 = private unnamed_addr constant [36 x i8] c"javax/security/cert/X509Certificate\00", align 16
@.str.4 = private unnamed_addr constant [28 x i8] c"javax/security/auth/Subject\00", align 16
@.str.5 = private unnamed_addr constant [24 x i8] c"javax/net/SocketFactory\00", align 16
@.str.6 = private unnamed_addr constant [33 x i8] c"javax/net/ssl/HttpsURLConnection\00", align 16
@.str.7 = private unnamed_addr constant [31 x i8] c"javax/net/ssl/HostnameVerifier\00", align 16
@.str.8 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/KeyManager\00", align 16
@.str.9 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/SSLSession\00", align 16
@.str.10 = private unnamed_addr constant [32 x i8] c"javax/net/ssl/SSLSessionContext\00", align 16
@.str.11 = private unnamed_addr constant [27 x i8] c"javax/net/ssl/TrustManager\00", align 16
@.str.12 = private unnamed_addr constant [32 x i8] c"javax/net/ssl/KeyManagerFactory\00", align 16
@.str.13 = private unnamed_addr constant [25 x i8] c"javax/net/ssl/SSLContext\00", align 16
@.str.14 = private unnamed_addr constant [31 x i8] c"javax/net/ssl/SSLSocketFactory\00", align 16
@.str.15 = private unnamed_addr constant [34 x i8] c"javax/net/ssl/TrustManagerFactory\00", align 16
@.str.16 = private unnamed_addr constant [30 x i8] c"android/widget/AbsoluteLayout\00", align 16
@.str.17 = private unnamed_addr constant [26 x i8] c"android/widget/AbsSpinner\00", align 16
@.str.18 = private unnamed_addr constant [27 x i8] c"android/widget/AdapterView\00", align 16
@.str.19 = private unnamed_addr constant [28 x i8] c"android/widget/ArrayAdapter\00", align 16
@.str.20 = private unnamed_addr constant [27 x i8] c"android/widget/BaseAdapter\00", align 16
@.str.21 = private unnamed_addr constant [22 x i8] c"android/widget/Button\00", align 16
@.str.22 = private unnamed_addr constant [24 x i8] c"android/widget/EditText\00", align 16
@.str.23 = private unnamed_addr constant [27 x i8] c"android/widget/FrameLayout\00", align 16
@.str.24 = private unnamed_addr constant [40 x i8] c"android/widget/FrameLayout$LayoutParams\00", align 16
@.str.25 = private unnamed_addr constant [23 x i8] c"android/widget/Adapter\00", align 16
@.str.26 = private unnamed_addr constant [30 x i8] c"android/widget/SpinnerAdapter\00", align 16
@.str.27 = private unnamed_addr constant [28 x i8] c"android/widget/LinearLayout\00", align 16
@.str.28 = private unnamed_addr constant [41 x i8] c"android/widget/LinearLayout$LayoutParams\00", align 16
@.str.29 = private unnamed_addr constant [27 x i8] c"android/widget/ProgressBar\00", align 16
@.str.30 = private unnamed_addr constant [26 x i8] c"android/widget/ScrollView\00", align 16
@.str.31 = private unnamed_addr constant [23 x i8] c"android/widget/Spinner\00", align 16
@.str.32 = private unnamed_addr constant [24 x i8] c"android/widget/TextView\00", align 16
@.str.33 = private unnamed_addr constant [47 x i8] c"android/widget/TextView$OnEditorActionListener\00", align 16
@.str.34 = private unnamed_addr constant [63 x i8] c"mono/android/widget/TextView_OnEditorActionListenerImplementor\00", align 16
@.str.35 = private unnamed_addr constant [29 x i8] c"android/webkit/CookieManager\00", align 16
@.str.36 = private unnamed_addr constant [29 x i8] c"android/webkit/ValueCallback\00", align 16
@.str.37 = private unnamed_addr constant [34 x i8] c"android/webkit/WebResourceRequest\00", align 16
@.str.38 = private unnamed_addr constant [24 x i8] c"android/webkit/JsResult\00", align 16
@.str.39 = private unnamed_addr constant [31 x i8] c"android/webkit/WebChromeClient\00", align 16
@.str.40 = private unnamed_addr constant [27 x i8] c"android/webkit/WebSettings\00", align 16
@.str.41 = private unnamed_addr constant [23 x i8] c"android/webkit/WebView\00", align 16
@.str.42 = private unnamed_addr constant [29 x i8] c"android/webkit/WebViewClient\00", align 16
@.str.43 = private unnamed_addr constant [28 x i8] c"android/util/DisplayMetrics\00", align 16
@.str.44 = private unnamed_addr constant [26 x i8] c"android/util/AttributeSet\00", align 16
@.str.45 = private unnamed_addr constant [22 x i8] c"android/os/BaseBundle\00", align 16
@.str.46 = private unnamed_addr constant [17 x i8] c"android/os/Build\00", align 16
@.str.47 = private unnamed_addr constant [25 x i8] c"android/os/Build$VERSION\00", align 16
@.str.48 = private unnamed_addr constant [18 x i8] c"android/os/Bundle\00", align 16
@.str.49 = private unnamed_addr constant [19 x i8] c"android/os/Handler\00", align 16
@.str.50 = private unnamed_addr constant [34 x i8] c"android/os/IBinder$DeathRecipient\00", align 16
@.str.51 = private unnamed_addr constant [19 x i8] c"android/os/IBinder\00", align 16
@.str.52 = private unnamed_addr constant [22 x i8] c"android/os/IInterface\00", align 16
@.str.53 = private unnamed_addr constant [18 x i8] c"android/os/Looper\00", align 16
@.str.54 = private unnamed_addr constant [18 x i8] c"android/os/Parcel\00", align 16
@.str.55 = private unnamed_addr constant [16 x i8] c"android/net/Uri\00", align 16
@.str.56 = private unnamed_addr constant [33 x i8] c"android/database/DataSetObserver\00", align 16
@.str.57 = private unnamed_addr constant [21 x i8] c"android/app/Activity\00", align 16
@.str.58 = private unnamed_addr constant [24 x i8] c"android/app/AlertDialog\00", align 16
@.str.59 = private unnamed_addr constant [32 x i8] c"android/app/AlertDialog$Builder\00", align 16
@.str.60 = private unnamed_addr constant [24 x i8] c"android/app/Application\00", align 16
@.str.61 = private unnamed_addr constant [19 x i8] c"android/app/Dialog\00", align 16
@.str.62 = private unnamed_addr constant [25 x i8] c"android/app/Notification\00", align 16
@.str.63 = private unnamed_addr constant [33 x i8] c"android/app/Notification$Builder\00", align 16
@.str.64 = private unnamed_addr constant [32 x i8] c"android/app/NotificationChannel\00", align 16
@.str.65 = private unnamed_addr constant [32 x i8] c"android/app/NotificationManager\00", align 16
@.str.66 = private unnamed_addr constant [26 x i8] c"android/app/PendingIntent\00", align 16
@.str.67 = private unnamed_addr constant [33 x i8] c"android/view/ContextThemeWrapper\00", align 16
@.str.68 = private unnamed_addr constant [24 x i8] c"android/view/InputEvent\00", align 16
@.str.69 = private unnamed_addr constant [22 x i8] c"android/view/KeyEvent\00", align 16
@.str.70 = private unnamed_addr constant [25 x i8] c"android/view/MotionEvent\00", align 16
@.str.71 = private unnamed_addr constant [18 x i8] c"android/view/View\00", align 16
@.str.72 = private unnamed_addr constant [34 x i8] c"android/view/View$OnClickListener\00", align 16
@.str.73 = private unnamed_addr constant [50 x i8] c"mono/android/view/View_OnClickListenerImplementor\00", align 16
@.str.74 = private unnamed_addr constant [34 x i8] c"android/view/View$OnTouchListener\00", align 16
@.str.75 = private unnamed_addr constant [50 x i8] c"mono/android/view/View_OnTouchListenerImplementor\00", align 16
@.str.76 = private unnamed_addr constant [23 x i8] c"android/view/ViewGroup\00", align 16
@.str.77 = private unnamed_addr constant [36 x i8] c"android/view/ViewGroup$LayoutParams\00", align 16
@.str.78 = private unnamed_addr constant [42 x i8] c"android/view/ViewGroup$MarginLayoutParams\00", align 16
@.str.79 = private unnamed_addr constant [20 x i8] c"android/view/Window\00", align 16
@.str.80 = private unnamed_addr constant [44 x i8] c"android/view/inputmethod/InputMethodManager\00", align 16
@.str.81 = private unnamed_addr constant [40 x i8] c"mono/android/runtime/InputStreamAdapter\00", align 16
@.str.82 = private unnamed_addr constant [31 x i8] c"mono/android/runtime/JavaArray\00", align 16
@.str.83 = private unnamed_addr constant [21 x i8] c"java/util/Collection\00", align 16
@.str.84 = private unnamed_addr constant [18 x i8] c"java/util/HashMap\00", align 16
@.str.85 = private unnamed_addr constant [20 x i8] c"java/util/ArrayList\00", align 16
@.str.86 = private unnamed_addr constant [32 x i8] c"mono/android/runtime/JavaObject\00", align 16
@.str.87 = private unnamed_addr constant [35 x i8] c"android/runtime/JavaProxyThrowable\00", align 16
@.str.88 = private unnamed_addr constant [18 x i8] c"java/util/HashSet\00", align 16
@.str.89 = private unnamed_addr constant [41 x i8] c"mono/android/runtime/OutputStreamAdapter\00", align 16
@.str.90 = private unnamed_addr constant [40 x i8] c"android/runtime/XmlReaderResourceParser\00", align 16
@.str.91 = private unnamed_addr constant [36 x i8] c"android/runtime/XmlReaderPullParser\00", align 16
@.str.92 = private unnamed_addr constant [24 x i8] c"android/graphics/Bitmap\00", align 16
@.str.93 = private unnamed_addr constant [26 x i8] c"android/graphics/Typeface\00", align 16
@.str.94 = private unnamed_addr constant [24 x i8] c"android/content/Context\00", align 16
@.str.95 = private unnamed_addr constant [31 x i8] c"android/content/ContextWrapper\00", align 16
@.str.96 = private unnamed_addr constant [48 x i8] c"android/content/DialogInterface$OnClickListener\00", align 16
@.str.97 = private unnamed_addr constant [64 x i8] c"mono/android/content/DialogInterface_OnClickListenerImplementor\00", align 16
@.str.98 = private unnamed_addr constant [32 x i8] c"android/content/DialogInterface\00", align 16
@.str.99 = private unnamed_addr constant [23 x i8] c"android/content/Intent\00", align 16
@.str.100 = private unnamed_addr constant [41 x i8] c"android/content/SharedPreferences$Editor\00", align 16
@.str.101 = private unnamed_addr constant [67 x i8] c"android/content/SharedPreferences$OnSharedPreferenceChangeListener\00", align 16
@.str.102 = private unnamed_addr constant [34 x i8] c"android/content/SharedPreferences\00", align 16
@.str.103 = private unnamed_addr constant [38 x i8] c"android/content/res/XmlResourceParser\00", align 16
@.str.104 = private unnamed_addr constant [30 x i8] c"android/content/res/Resources\00", align 16
@.str.105 = private unnamed_addr constant [22 x i8] c"java/util/Enumeration\00", align 16
@.str.106 = private unnamed_addr constant [19 x i8] c"java/util/Iterator\00", align 16
@.str.107 = private unnamed_addr constant [17 x i8] c"java/util/Random\00", align 16
@.str.108 = private unnamed_addr constant [28 x i8] c"java/util/function/Consumer\00", align 16
@.str.109 = private unnamed_addr constant [24 x i8] c"java/security/Principal\00", align 16
@.str.110 = private unnamed_addr constant [23 x i8] c"java/security/KeyStore\00", align 16
@.str.111 = private unnamed_addr constant [27 x i8] c"java/security/SecureRandom\00", align 16
@.str.112 = private unnamed_addr constant [31 x i8] c"java/security/cert/Certificate\00", align 16
@.str.113 = private unnamed_addr constant [30 x i8] c"java/nio/channels/FileChannel\00", align 16
@.str.114 = private unnamed_addr constant [51 x i8] c"java/nio/channels/spi/AbstractInterruptibleChannel\00", align 16
@.str.115 = private unnamed_addr constant [26 x i8] c"java/net/ConnectException\00", align 16
@.str.116 = private unnamed_addr constant [27 x i8] c"java/net/HttpURLConnection\00", align 16
@.str.117 = private unnamed_addr constant [27 x i8] c"java/net/InetSocketAddress\00", align 16
@.str.118 = private unnamed_addr constant [27 x i8] c"java/net/ProtocolException\00", align 16
@.str.119 = private unnamed_addr constant [15 x i8] c"java/net/Proxy\00", align 1
@.str.120 = private unnamed_addr constant [20 x i8] c"java/net/Proxy$Type\00", align 16
@.str.121 = private unnamed_addr constant [23 x i8] c"java/net/SocketAddress\00", align 16
@.str.122 = private unnamed_addr constant [25 x i8] c"java/net/SocketException\00", align 16
@.str.123 = private unnamed_addr constant [32 x i8] c"java/net/SocketTimeoutException\00", align 16
@.str.124 = private unnamed_addr constant [33 x i8] c"java/net/UnknownServiceException\00", align 16
@.str.125 = private unnamed_addr constant [13 x i8] c"java/net/URL\00", align 1
@.str.126 = private unnamed_addr constant [23 x i8] c"java/net/URLConnection\00", align 16
@.str.127 = private unnamed_addr constant [23 x i8] c"java/io/FileDescriptor\00", align 16
@.str.128 = private unnamed_addr constant [24 x i8] c"java/io/FileInputStream\00", align 16
@.str.129 = private unnamed_addr constant [20 x i8] c"java/io/InputStream\00", align 16
@.str.130 = private unnamed_addr constant [31 x i8] c"java/io/InterruptedIOException\00", align 16
@.str.131 = private unnamed_addr constant [20 x i8] c"java/io/IOException\00", align 16
@.str.132 = private unnamed_addr constant [21 x i8] c"java/io/OutputStream\00", align 16
@.str.133 = private unnamed_addr constant [20 x i8] c"java/io/PrintWriter\00", align 16
@.str.134 = private unnamed_addr constant [15 x i8] c"java/io/Reader\00", align 1
@.str.135 = private unnamed_addr constant [21 x i8] c"java/io/StringWriter\00", align 16
@.str.136 = private unnamed_addr constant [15 x i8] c"java/io/Writer\00", align 1
@.str.137 = private unnamed_addr constant [18 x i8] c"java/lang/Boolean\00", align 16
@.str.138 = private unnamed_addr constant [15 x i8] c"java/lang/Byte\00", align 1
@.str.139 = private unnamed_addr constant [20 x i8] c"java/lang/Character\00", align 16
@.str.140 = private unnamed_addr constant [16 x i8] c"java/lang/Class\00", align 16
@.str.141 = private unnamed_addr constant [29 x i8] c"java/lang/ClassCastException\00", align 16
@.str.142 = private unnamed_addr constant [17 x i8] c"java/lang/Double\00", align 16
@.str.143 = private unnamed_addr constant [15 x i8] c"java/lang/Enum\00", align 1
@.str.144 = private unnamed_addr constant [16 x i8] c"java/lang/Error\00", align 16
@.str.145 = private unnamed_addr constant [20 x i8] c"java/lang/Exception\00", align 16
@.str.146 = private unnamed_addr constant [16 x i8] c"java/lang/Float\00", align 16
@.str.147 = private unnamed_addr constant [23 x i8] c"java/lang/CharSequence\00", align 16
@.str.148 = private unnamed_addr constant [35 x i8] c"java/lang/IllegalArgumentException\00", align 16
@.str.149 = private unnamed_addr constant [32 x i8] c"java/lang/IllegalStateException\00", align 16
@.str.150 = private unnamed_addr constant [36 x i8] c"java/lang/IndexOutOfBoundsException\00", align 16
@.str.151 = private unnamed_addr constant [18 x i8] c"java/lang/Integer\00", align 16
@.str.152 = private unnamed_addr constant [19 x i8] c"java/lang/Runnable\00", align 16
@.str.153 = private unnamed_addr constant [15 x i8] c"java/lang/Long\00", align 1
@.str.154 = private unnamed_addr constant [31 x i8] c"java/lang/NullPointerException\00", align 16
@.str.155 = private unnamed_addr constant [17 x i8] c"java/lang/Number\00", align 16
@.str.156 = private unnamed_addr constant [17 x i8] c"java/lang/Object\00", align 16
@.str.157 = private unnamed_addr constant [27 x i8] c"java/lang/RuntimeException\00", align 16
@.str.158 = private unnamed_addr constant [28 x i8] c"java/lang/SecurityException\00", align 16
@.str.159 = private unnamed_addr constant [16 x i8] c"java/lang/Short\00", align 16
@.str.160 = private unnamed_addr constant [28 x i8] c"java/lang/StackTraceElement\00", align 16
@.str.161 = private unnamed_addr constant [17 x i8] c"java/lang/String\00", align 16
@.str.162 = private unnamed_addr constant [17 x i8] c"java/lang/Thread\00", align 16
@.str.163 = private unnamed_addr constant [35 x i8] c"mono/java/lang/RunnableImplementor\00", align 16
@.str.164 = private unnamed_addr constant [20 x i8] c"java/lang/Throwable\00", align 16
@.str.165 = private unnamed_addr constant [40 x i8] c"java/lang/UnsupportedOperationException\00", align 16
@.str.166 = private unnamed_addr constant [25 x i8] c"mono/android/TypeManager\00", align 16
@.str.167 = private unnamed_addr constant [35 x i8] c"crc640779913324aae7e9/MainActivity\00", align 16
@.str.168 = private unnamed_addr constant [58 x i8] c"crc640779913324aae7e9/MainActivity_DashboardWebViewClient\00", align 16
@.str.169 = private unnamed_addr constant [60 x i8] c"crc640779913324aae7e9/MainActivity_DashboardWebChromeClient\00", align 16
@.str.170 = private unnamed_addr constant [61 x i8] c"crc640779913324aae7e9/MainActivity_DashboardJavascriptBridge\00", align 16

;TypeMapModule
@.TypeMapModule.0_assembly_name = private unnamed_addr constant [13 x i8] c"Mono.Android\00", align 1
@.TypeMapModule.1_assembly_name = private unnamed_addr constant [23 x i8] c"PisonetManager.Android\00", align 16

; Metadata
!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.4xx @ 82d8938cf80f6d5fa6c28529ddfbdb753d805ab4"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
