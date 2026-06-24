; ModuleID = 'marshal_methods.x86_64.ll'
source_filename = "marshal_methods.x86_64.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [28 x ptr] zeroinitializer, align 16

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [56 x i64] [
	i64 120698629574877762, ; 0: Mono.Android => 0x1accec39cafe242 => 27
	i64 1476839205573959279, ; 1: System.Net.Primitives.dll => 0x147ec96ece9b1e6f => 13
	i64 1513467482682125403, ; 2: Mono.Android.Runtime => 0x1500eaa8245f6c5b => 26
	i64 1743969030606105336, ; 3: System.Memory.dll => 0x1833d297e88f2af8 => 10
	i64 1767386781656293639, ; 4: System.Private.Uri.dll => 0x188704e9f5582107 => 15
	i64 2287834202362508563, ; 5: System.Collections.Concurrent => 0x1fc00515e8ce7513 => 2
	i64 2335503487726329082, ; 6: System.Text.Encodings.Web => 0x2069600c4d9d1cfa => 20
	i64 2497223385847772520, ; 7: System.Runtime => 0x22a7eb7046413568 => 18
	i64 3551103847008531295, ; 8: System.Private.CoreLib.dll => 0x31480e226177735f => 23
	i64 3571415421602489686, ; 9: System.Runtime.dll => 0x319037675df7e556 => 18
	i64 3933965368022646939, ; 10: System.Net.Requests => 0x369840a8bfadc09b => 14
	i64 3966267475168208030, ; 11: System.Memory => 0x370b03412596249e => 10
	i64 4073500526318903918, ; 12: System.Private.Xml.dll => 0x3887fb25779ae26e => 16
	i64 5361256753019689847, ; 13: PisonetManager.Android.dll => 0x4a67029c99671b77 => 1
	i64 5570799893513421663, ; 14: System.IO.Compression.Brotli => 0x4d4f74fcdfa6c35f => 7
	i64 5573260873512690141, ; 15: System.Security.Cryptography.dll => 0x4d58333c6e4ea1dd => 19
	i64 6222399776351216807, ; 16: System.Text.Json.dll => 0x565a67a0ffe264a7 => 21
	i64 6357457916754632952, ; 17: _Microsoft.Android.Resource.Designer => 0x583a3a4ac2a7a0f8 => 0
	i64 7270811800166795866, ; 18: System.Linq => 0x64e71ccf51a90a5a => 9
	i64 7654504624184590948, ; 19: System.Net.Http => 0x6a3a4366801b8264 => 12
	i64 7714652370974252055, ; 20: System.Private.CoreLib => 0x6b0ff375198b9c17 => 23
	i64 8064050204834738623, ; 21: System.Collections.dll => 0x6fe942efa61731bf => 4
	i64 8085230611270010360, ; 22: System.Net.Http.Json.dll => 0x703482674fdd05f8 => 11
	i64 8087206902342787202, ; 23: System.Diagnostics.DiagnosticSource => 0x703b87d46f3aa082 => 6
	i64 8167236081217502503, ; 24: Java.Interop.dll => 0x7157d9f1a9b8fd27 => 24
	i64 8185542183669246576, ; 25: System.Collections => 0x7198e33f4794aa70 => 4
	i64 8368701292315763008, ; 26: System.Security.Cryptography => 0x7423997c6fd56140 => 19
	i64 8563666267364444763, ; 27: System.Private.Uri => 0x76d841191140ca5b => 15
	i64 8626175481042262068, ; 28: Java.Interop => 0x77b654e585b55834 => 24
	i64 8725526185868997716, ; 29: System.Diagnostics.DiagnosticSource.dll => 0x79174bd613173454 => 6
	i64 9659729154652888475, ; 30: System.Text.RegularExpressions => 0x860e407c9991dd9b => 22
	i64 9702891218465930390, ; 31: System.Collections.NonGeneric.dll => 0x86a79827b2eb3c96 => 3
	i64 9808709177481450983, ; 32: Mono.Android.dll => 0x881f890734e555e7 => 27
	i64 10038780035334861115, ; 33: System.Net.Http.dll => 0x8b50e941206af13b => 12
	i64 10051358222726253779, ; 34: System.Private.Xml => 0x8b7d990c97ccccd3 => 16
	i64 10785150219063592792, ; 35: System.Net.Primitives => 0x95ac8cfb68830758 => 13
	i64 11446671985764974897, ; 36: Mono.Android.Export => 0x9edabf8623efc131 => 25
	i64 11485890710487134646, ; 37: System.Runtime.InteropServices => 0x9f6614bf0f8b71b6 => 17
	i64 12145679461940342714, ; 38: System.Text.Json => 0xa88e1f1ebcb62fba => 21
	i64 12475113361194491050, ; 39: _Microsoft.Android.Resource.Designer.dll => 0xad2081818aba1caa => 0
	i64 12550732019250633519, ; 40: System.IO.Compression => 0xae2d28465e8e1b2f => 8
	i64 13343850469010654401, ; 41: Mono.Android.Runtime.dll => 0xb92ee14d854f44c1 => 26
	i64 13881769479078963060, ; 42: System.Console.dll => 0xc0a5f3cade5c6774 => 5
	i64 14055321406860664556, ; 43: PisonetManager.Android => 0xc30e8859ebdf9eec => 1
	i64 14461014870687870182, ; 44: System.Net.Requests.dll => 0xc8afd8683afdece6 => 14
	i64 14551742072151931844, ; 45: System.Text.Encodings.Web.dll => 0xc9f22c50f1b8fbc4 => 20
	i64 14987728460634540364, ; 46: System.IO.Compression.dll => 0xcfff1ba06622494c => 8
	i64 15024878362326791334, ; 47: System.Net.Http.Json => 0xd0831743ebf0f4a6 => 11
	i64 15115185479366240210, ; 48: System.IO.Compression.Brotli.dll => 0xd1c3ed1c1bc467d2 => 7
	i64 15133485256822086103, ; 49: System.Linq.dll => 0xd204f0a9127dd9d7 => 9
	i64 15527772828719725935, ; 50: System.Console => 0xd77dbb1e38cd3d6f => 5
	i64 16496768397145114574, ; 51: Mono.Android.Export.dll => 0xe4f04b741db987ce => 25
	i64 16890310621557459193, ; 52: System.Text.RegularExpressions.dll => 0xea66700587f088f9 => 22
	i64 17008137082415910100, ; 53: System.Collections.NonGeneric => 0xec090a90408c8cd4 => 3
	i64 17712670374920797664, ; 54: System.Runtime.InteropServices.dll => 0xf5d00bdc38bd3de0 => 17
	i64 18245806341561545090 ; 55: System.Collections.Concurrent.dll => 0xfd3620327d587182 => 2
], align 16

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [56 x i32] [
	i32 27, ; 0
	i32 13, ; 1
	i32 26, ; 2
	i32 10, ; 3
	i32 15, ; 4
	i32 2, ; 5
	i32 20, ; 6
	i32 18, ; 7
	i32 23, ; 8
	i32 18, ; 9
	i32 14, ; 10
	i32 10, ; 11
	i32 16, ; 12
	i32 1, ; 13
	i32 7, ; 14
	i32 19, ; 15
	i32 21, ; 16
	i32 0, ; 17
	i32 9, ; 18
	i32 12, ; 19
	i32 23, ; 20
	i32 4, ; 21
	i32 11, ; 22
	i32 6, ; 23
	i32 24, ; 24
	i32 4, ; 25
	i32 19, ; 26
	i32 15, ; 27
	i32 24, ; 28
	i32 6, ; 29
	i32 22, ; 30
	i32 3, ; 31
	i32 27, ; 32
	i32 12, ; 33
	i32 16, ; 34
	i32 13, ; 35
	i32 25, ; 36
	i32 17, ; 37
	i32 21, ; 38
	i32 0, ; 39
	i32 8, ; 40
	i32 26, ; 41
	i32 5, ; 42
	i32 1, ; 43
	i32 14, ; 44
	i32 20, ; 45
	i32 8, ; 46
	i32 11, ; 47
	i32 7, ; 48
	i32 9, ; 49
	i32 5, ; 50
	i32 25, ; 51
	i32 22, ; 52
	i32 3, ; 53
	i32 17, ; 54
	i32 2 ; 55
], align 16

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 8

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 8

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 0, ; id 0x0; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 8

; Functions

; Function attributes: "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" uwtable willreturn
define void @xamarin_app_init(ptr nocapture noundef readnone %env, ptr noundef %fn) local_unnamed_addr #0
{
	%fnIsNull = icmp eq ptr %fn, null
	br i1 %fnIsNull, label %1, label %2

1: ; preds = %0
	%putsResult = call noundef i32 @puts(ptr @.str.0)
	call void @abort()
	unreachable 

2: ; preds = %1, %0
	store ptr %fn, ptr @get_function_pointer, align 8, !tbaa !3
	ret void
}

; Strings
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 16

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+crc32,+cx16,+cx8,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87" "tune-cpu"="generic" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+crc32,+cx16,+cx8,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87" "tune-cpu"="generic" }

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
