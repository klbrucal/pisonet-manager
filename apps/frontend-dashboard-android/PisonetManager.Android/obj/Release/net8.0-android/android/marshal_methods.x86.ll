; ModuleID = 'marshal_methods.x86.ll'
source_filename = "marshal_methods.x86.ll"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i686-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [28 x ptr] zeroinitializer, align 4

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [56 x i32] [
	i32 117431740, ; 0: System.Runtime.InteropServices => 0x6ffddbc => 17
	i32 385762202, ; 1: System.Memory.dll => 0x16fe439a => 10
	i32 395744057, ; 2: _Microsoft.Android.Resource.Designer => 0x17969339 => 0
	i32 442565967, ; 3: System.Collections => 0x1a61054f => 4
	i32 620006439, ; 4: PisonetManager.Android => 0x24f48c27 => 1
	i32 662205335, ; 5: System.Text.Encodings.Web.dll => 0x27787397 => 20
	i32 672442732, ; 6: System.Collections.Concurrent => 0x2814a96c => 2
	i32 759454413, ; 7: System.Net.Requests => 0x2d445acd => 14
	i32 775507847, ; 8: System.IO.Compression => 0x2e394f87 => 8
	i32 823281589, ; 9: System.Private.Uri.dll => 0x311247b5 => 15
	i32 830298997, ; 10: System.IO.Compression.Brotli => 0x317d5b75 => 7
	i32 878954865, ; 11: System.Net.Http.Json => 0x3463c971 => 11
	i32 992768348, ; 12: System.Collections.dll => 0x3b2c715c => 4
	i32 1324164729, ; 13: System.Linq => 0x4eed2679 => 9
	i32 1462112819, ; 14: System.IO.Compression.dll => 0x57261233 => 8
	i32 1480492111, ; 15: System.IO.Compression.Brotli.dll => 0x583e844f => 7
	i32 1543031311, ; 16: System.Text.RegularExpressions.dll => 0x5bf8ca0f => 22
	i32 1639515021, ; 17: System.Net.Http.dll => 0x61b9038d => 12
	i32 1639986890, ; 18: System.Text.RegularExpressions => 0x61c036ca => 22
	i32 1657153582, ; 19: System.Runtime => 0x62c6282e => 18
	i32 1677501392, ; 20: System.Net.Primitives.dll => 0x63fca3d0 => 13
	i32 1679769178, ; 21: System.Security.Cryptography => 0x641f3e5a => 19
	i32 1746316138, ; 22: Mono.Android.Export => 0x6816ab6a => 25
	i32 1780572499, ; 23: Mono.Android.Runtime.dll => 0x6a216153 => 26
	i32 1910275211, ; 24: System.Collections.NonGeneric.dll => 0x71dc7c8b => 3
	i32 2045470958, ; 25: System.Private.Xml => 0x79eb68ee => 16
	i32 2079903147, ; 26: System.Runtime.dll => 0x7bf8cdab => 18
	i32 2127167465, ; 27: System.Console => 0x7ec9ffe9 => 5
	i32 2201231467, ; 28: System.Net.Http => 0x8334206b => 12
	i32 2305521784, ; 29: System.Private.CoreLib.dll => 0x896b7878 => 23
	i32 2353062107, ; 30: System.Net.Primitives => 0x8c40e0db => 13
	i32 2435356389, ; 31: System.Console.dll => 0x912896e5 => 5
	i32 2475788418, ; 32: Java.Interop.dll => 0x93918882 => 24
	i32 2570120770, ; 33: System.Text.Encodings.Web => 0x9930ee42 => 20
	i32 2617129537, ; 34: System.Private.Xml.dll => 0x9bfe3a41 => 16
	i32 2861098320, ; 35: Mono.Android.Export.dll => 0xaa88e550 => 25
	i32 2909740682, ; 36: System.Private.CoreLib => 0xad6f1e8a => 23
	i32 3038032645, ; 37: _Microsoft.Android.Resource.Designer.dll => 0xb514b305 => 0
	i32 3059408633, ; 38: Mono.Android.Runtime => 0xb65adef9 => 26
	i32 3316684772, ; 39: System.Net.Requests.dll => 0xc5b097e4 => 14
	i32 3358260929, ; 40: System.Text.Json => 0xc82afec1 => 21
	i32 3366347497, ; 41: Java.Interop => 0xc8a662e9 => 24
	i32 3476120550, ; 42: Mono.Android => 0xcf3163e6 => 27
	i32 3485117614, ; 43: System.Text.Json.dll => 0xcfbaacae => 21
	i32 3608519521, ; 44: System.Linq.dll => 0xd715a361 => 9
	i32 3672681054, ; 45: Mono.Android.dll => 0xdae8aa5e => 27
	i32 3737834244, ; 46: System.Net.Http.Json.dll => 0xdecad304 => 11
	i32 3748608112, ; 47: System.Diagnostics.DiagnosticSource => 0xdf6f3870 => 6
	i32 3792276235, ; 48: System.Collections.NonGeneric => 0xe2098b0b => 3
	i32 3823082795, ; 49: System.Security.Cryptography.dll => 0xe3df9d2b => 19
	i32 3849253459, ; 50: System.Runtime.InteropServices.dll => 0xe56ef253 => 17
	i32 3896106733, ; 51: System.Collections.Concurrent.dll => 0xe839deed => 2
	i32 3908807782, ; 52: PisonetManager.Android.dll => 0xe8fbac66 => 1
	i32 4025784931, ; 53: System.Memory => 0xeff49a63 => 10
	i32 4100113165, ; 54: System.Private.Uri => 0xf462c30d => 15
	i32 4213026141 ; 55: System.Diagnostics.DiagnosticSource.dll => 0xfb1dad5d => 6
], align 4

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [56 x i32] [
	i32 17, ; 0
	i32 10, ; 1
	i32 0, ; 2
	i32 4, ; 3
	i32 1, ; 4
	i32 20, ; 5
	i32 2, ; 6
	i32 14, ; 7
	i32 8, ; 8
	i32 15, ; 9
	i32 7, ; 10
	i32 11, ; 11
	i32 4, ; 12
	i32 9, ; 13
	i32 8, ; 14
	i32 7, ; 15
	i32 22, ; 16
	i32 12, ; 17
	i32 22, ; 18
	i32 18, ; 19
	i32 13, ; 20
	i32 19, ; 21
	i32 25, ; 22
	i32 26, ; 23
	i32 3, ; 24
	i32 16, ; 25
	i32 18, ; 26
	i32 5, ; 27
	i32 12, ; 28
	i32 23, ; 29
	i32 13, ; 30
	i32 5, ; 31
	i32 24, ; 32
	i32 20, ; 33
	i32 16, ; 34
	i32 25, ; 35
	i32 23, ; 36
	i32 0, ; 37
	i32 26, ; 38
	i32 14, ; 39
	i32 21, ; 40
	i32 24, ; 41
	i32 27, ; 42
	i32 21, ; 43
	i32 9, ; 44
	i32 27, ; 45
	i32 11, ; 46
	i32 6, ; 47
	i32 3, ; 48
	i32 19, ; 49
	i32 17, ; 50
	i32 2, ; 51
	i32 1, ; 52
	i32 10, ; 53
	i32 15, ; 54
	i32 6 ; 55
], align 4

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 4

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 4

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 0, ; id 0x0; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 4

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
	store ptr %fn, ptr @get_function_pointer, align 4, !tbaa !3
	ret void
}

; Strings
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 1

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" }

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
