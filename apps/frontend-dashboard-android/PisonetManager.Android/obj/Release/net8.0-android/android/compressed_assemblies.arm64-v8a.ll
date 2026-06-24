; ModuleID = 'compressed_assemblies.arm64-v8a.ll'
source_filename = "compressed_assemblies.arm64-v8a.ll"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-android21"

%struct.CompressedAssemblies = type {
	i32, ; uint32_t count
	ptr ; CompressedAssemblyDescriptor descriptors
}

%struct.CompressedAssemblyDescriptor = type {
	i32, ; uint32_t uncompressed_file_size
	i8, ; bool loaded
	ptr ; uint8_t data
}

@compressed_assemblies = dso_local local_unnamed_addr global %struct.CompressedAssemblies {
	i32 43, ; uint32_t count (0x2b)
	ptr @compressed_assembly_descriptors; CompressedAssemblyDescriptor* descriptors
}, align 8

@compressed_assembly_descriptors = internal dso_local global [43 x %struct.CompressedAssemblyDescriptor] [
	%struct.CompressedAssemblyDescriptor {
		i32 136192, ; uint32_t uncompressed_file_size (0x21400)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_0; uint8_t* data (0x0)
	}, ; 0
	%struct.CompressedAssemblyDescriptor {
		i32 30208, ; uint32_t uncompressed_file_size (0x7600)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_1; uint8_t* data (0x0)
	}, ; 1
	%struct.CompressedAssemblyDescriptor {
		i32 18984, ; uint32_t uncompressed_file_size (0x4a28)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_2; uint8_t* data (0x0)
	}, ; 2
	%struct.CompressedAssemblyDescriptor {
		i32 589312, ; uint32_t uncompressed_file_size (0x8fe00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_3; uint8_t* data (0x0)
	}, ; 3
	%struct.CompressedAssemblyDescriptor {
		i32 23040, ; uint32_t uncompressed_file_size (0x5a00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_4; uint8_t* data (0x0)
	}, ; 4
	%struct.CompressedAssemblyDescriptor {
		i32 11264, ; uint32_t uncompressed_file_size (0x2c00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_5; uint8_t* data (0x0)
	}, ; 5
	%struct.CompressedAssemblyDescriptor {
		i32 7168, ; uint32_t uncompressed_file_size (0x1c00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_6; uint8_t* data (0x0)
	}, ; 6
	%struct.CompressedAssemblyDescriptor {
		i32 10752, ; uint32_t uncompressed_file_size (0x2a00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_7; uint8_t* data (0x0)
	}, ; 7
	%struct.CompressedAssemblyDescriptor {
		i32 14848, ; uint32_t uncompressed_file_size (0x3a00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_8; uint8_t* data (0x0)
	}, ; 8
	%struct.CompressedAssemblyDescriptor {
		i32 19968, ; uint32_t uncompressed_file_size (0x4e00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_9; uint8_t* data (0x0)
	}, ; 9
	%struct.CompressedAssemblyDescriptor {
		i32 29696, ; uint32_t uncompressed_file_size (0x7400)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_10; uint8_t* data (0x0)
	}, ; 10
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uint32_t uncompressed_file_size (0x4000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_11; uint8_t* data (0x0)
	}, ; 11
	%struct.CompressedAssemblyDescriptor {
		i32 12288, ; uint32_t uncompressed_file_size (0x3000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_12; uint8_t* data (0x0)
	}, ; 12
	%struct.CompressedAssemblyDescriptor {
		i32 9728, ; uint32_t uncompressed_file_size (0x2600)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_13; uint8_t* data (0x0)
	}, ; 13
	%struct.CompressedAssemblyDescriptor {
		i32 121344, ; uint32_t uncompressed_file_size (0x1da00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_14; uint8_t* data (0x0)
	}, ; 14
	%struct.CompressedAssemblyDescriptor {
		i32 33280, ; uint32_t uncompressed_file_size (0x8200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_15; uint8_t* data (0x0)
	}, ; 15
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size (0x1800)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_16; uint8_t* data (0x0)
	}, ; 16
	%struct.CompressedAssemblyDescriptor {
		i32 66048, ; uint32_t uncompressed_file_size (0x10200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_17; uint8_t* data (0x0)
	}, ; 17
	%struct.CompressedAssemblyDescriptor {
		i32 377344, ; uint32_t uncompressed_file_size (0x5c200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_18; uint8_t* data (0x0)
	}, ; 18
	%struct.CompressedAssemblyDescriptor {
		i32 8192, ; uint32_t uncompressed_file_size (0x2000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_19; uint8_t* data (0x0)
	}, ; 19
	%struct.CompressedAssemblyDescriptor {
		i32 6656, ; uint32_t uncompressed_file_size (0x1a00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_20; uint8_t* data (0x0)
	}, ; 20
	%struct.CompressedAssemblyDescriptor {
		i32 13312, ; uint32_t uncompressed_file_size (0x3400)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_21; uint8_t* data (0x0)
	}, ; 21
	%struct.CompressedAssemblyDescriptor {
		i32 13824, ; uint32_t uncompressed_file_size (0x3600)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_22; uint8_t* data (0x0)
	}, ; 22
	%struct.CompressedAssemblyDescriptor {
		i32 16896, ; uint32_t uncompressed_file_size (0x4200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_23; uint8_t* data (0x0)
	}, ; 23
	%struct.CompressedAssemblyDescriptor {
		i32 1490944, ; uint32_t uncompressed_file_size (0x16c000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_24; uint8_t* data (0x0)
	}, ; 24
	%struct.CompressedAssemblyDescriptor {
		i32 31232, ; uint32_t uncompressed_file_size (0x7a00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_25; uint8_t* data (0x0)
	}, ; 25
	%struct.CompressedAssemblyDescriptor {
		i32 253952, ; uint32_t uncompressed_file_size (0x3e000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_26; uint8_t* data (0x0)
	}, ; 26
	%struct.CompressedAssemblyDescriptor {
		i32 2560, ; uint32_t uncompressed_file_size (0xa00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_27; uint8_t* data (0x0)
	}, ; 27
	%struct.CompressedAssemblyDescriptor {
		i32 16896, ; uint32_t uncompressed_file_size (0x4200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_28; uint8_t* data (0x0)
	}, ; 28
	%struct.CompressedAssemblyDescriptor {
		i32 1476608, ; uint32_t uncompressed_file_size (0x168800)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_29; uint8_t* data (0x0)
	}, ; 29
	%struct.CompressedAssemblyDescriptor {
		i32 28160, ; uint32_t uncompressed_file_size (0x6e00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_30; uint8_t* data (0x0)
	}, ; 30
	%struct.CompressedAssemblyDescriptor {
		i32 254464, ; uint32_t uncompressed_file_size (0x3e200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_31; uint8_t* data (0x0)
	}, ; 31
	%struct.CompressedAssemblyDescriptor {
		i32 2560, ; uint32_t uncompressed_file_size (0xa00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_32; uint8_t* data (0x0)
	}, ; 32
	%struct.CompressedAssemblyDescriptor {
		i32 16896, ; uint32_t uncompressed_file_size (0x4200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_33; uint8_t* data (0x0)
	}, ; 33
	%struct.CompressedAssemblyDescriptor {
		i32 1476096, ; uint32_t uncompressed_file_size (0x168600)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_34; uint8_t* data (0x0)
	}, ; 34
	%struct.CompressedAssemblyDescriptor {
		i32 28160, ; uint32_t uncompressed_file_size (0x6e00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_35; uint8_t* data (0x0)
	}, ; 35
	%struct.CompressedAssemblyDescriptor {
		i32 254464, ; uint32_t uncompressed_file_size (0x3e200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_36; uint8_t* data (0x0)
	}, ; 36
	%struct.CompressedAssemblyDescriptor {
		i32 2560, ; uint32_t uncompressed_file_size (0xa00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_37; uint8_t* data (0x0)
	}, ; 37
	%struct.CompressedAssemblyDescriptor {
		i32 16896, ; uint32_t uncompressed_file_size (0x4200)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_38; uint8_t* data (0x0)
	}, ; 38
	%struct.CompressedAssemblyDescriptor {
		i32 1538048, ; uint32_t uncompressed_file_size (0x177800)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_39; uint8_t* data (0x0)
	}, ; 39
	%struct.CompressedAssemblyDescriptor {
		i32 30208, ; uint32_t uncompressed_file_size (0x7600)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_40; uint8_t* data (0x0)
	}, ; 40
	%struct.CompressedAssemblyDescriptor {
		i32 253952, ; uint32_t uncompressed_file_size (0x3e000)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_41; uint8_t* data (0x0)
	}, ; 41
	%struct.CompressedAssemblyDescriptor {
		i32 2560, ; uint32_t uncompressed_file_size (0xa00)
		i8 0, ; bool loaded
		ptr @__compressedAssemblyData_42; uint8_t* data (0x0)
	} ; 42
], align 8

@__compressedAssemblyData_0 = internal dso_local global [136192 x i8] zeroinitializer, align 1
@__compressedAssemblyData_1 = internal dso_local global [30208 x i8] zeroinitializer, align 1
@__compressedAssemblyData_2 = internal dso_local global [18984 x i8] zeroinitializer, align 1
@__compressedAssemblyData_3 = internal dso_local global [589312 x i8] zeroinitializer, align 1
@__compressedAssemblyData_4 = internal dso_local global [23040 x i8] zeroinitializer, align 1
@__compressedAssemblyData_5 = internal dso_local global [11264 x i8] zeroinitializer, align 1
@__compressedAssemblyData_6 = internal dso_local global [7168 x i8] zeroinitializer, align 1
@__compressedAssemblyData_7 = internal dso_local global [10752 x i8] zeroinitializer, align 1
@__compressedAssemblyData_8 = internal dso_local global [14848 x i8] zeroinitializer, align 1
@__compressedAssemblyData_9 = internal dso_local global [19968 x i8] zeroinitializer, align 1
@__compressedAssemblyData_10 = internal dso_local global [29696 x i8] zeroinitializer, align 1
@__compressedAssemblyData_11 = internal dso_local global [16384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_12 = internal dso_local global [12288 x i8] zeroinitializer, align 1
@__compressedAssemblyData_13 = internal dso_local global [9728 x i8] zeroinitializer, align 1
@__compressedAssemblyData_14 = internal dso_local global [121344 x i8] zeroinitializer, align 1
@__compressedAssemblyData_15 = internal dso_local global [33280 x i8] zeroinitializer, align 1
@__compressedAssemblyData_16 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_17 = internal dso_local global [66048 x i8] zeroinitializer, align 1
@__compressedAssemblyData_18 = internal dso_local global [377344 x i8] zeroinitializer, align 1
@__compressedAssemblyData_19 = internal dso_local global [8192 x i8] zeroinitializer, align 1
@__compressedAssemblyData_20 = internal dso_local global [6656 x i8] zeroinitializer, align 1
@__compressedAssemblyData_21 = internal dso_local global [13312 x i8] zeroinitializer, align 1
@__compressedAssemblyData_22 = internal dso_local global [13824 x i8] zeroinitializer, align 1
@__compressedAssemblyData_23 = internal dso_local global [16896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_24 = internal dso_local global [1490944 x i8] zeroinitializer, align 1
@__compressedAssemblyData_25 = internal dso_local global [31232 x i8] zeroinitializer, align 1
@__compressedAssemblyData_26 = internal dso_local global [253952 x i8] zeroinitializer, align 1
@__compressedAssemblyData_27 = internal dso_local global [2560 x i8] zeroinitializer, align 1
@__compressedAssemblyData_28 = internal dso_local global [16896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_29 = internal dso_local global [1476608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_30 = internal dso_local global [28160 x i8] zeroinitializer, align 1
@__compressedAssemblyData_31 = internal dso_local global [254464 x i8] zeroinitializer, align 1
@__compressedAssemblyData_32 = internal dso_local global [2560 x i8] zeroinitializer, align 1
@__compressedAssemblyData_33 = internal dso_local global [16896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_34 = internal dso_local global [1476096 x i8] zeroinitializer, align 1
@__compressedAssemblyData_35 = internal dso_local global [28160 x i8] zeroinitializer, align 1
@__compressedAssemblyData_36 = internal dso_local global [254464 x i8] zeroinitializer, align 1
@__compressedAssemblyData_37 = internal dso_local global [2560 x i8] zeroinitializer, align 1
@__compressedAssemblyData_38 = internal dso_local global [16896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_39 = internal dso_local global [1538048 x i8] zeroinitializer, align 1
@__compressedAssemblyData_40 = internal dso_local global [30208 x i8] zeroinitializer, align 1
@__compressedAssemblyData_41 = internal dso_local global [253952 x i8] zeroinitializer, align 1
@__compressedAssemblyData_42 = internal dso_local global [2560 x i8] zeroinitializer, align 1

; Metadata
!llvm.module.flags = !{!0, !1, !7, !8, !9, !10}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.4xx @ 82d8938cf80f6d5fa6c28529ddfbdb753d805ab4"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
