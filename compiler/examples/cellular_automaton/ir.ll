; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.surface_t = type { i8*, i32, i32 }

@.str = private unnamed_addr constant [13 x i8] c"buff != NULL\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"main.c\00", align 1
@__PRETTY_FUNCTION__.init_surface = private unnamed_addr constant [58 x i8] c"struct surface_t init_surface(unsigned int, unsigned int)\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local { i8*, i64 } @init_surface(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca %struct.surface_t, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  %7 = load i32, i32* %5, align 4
  %8 = load i32, i32* %4, align 4
  %9 = mul i32 %7, %8
  %10 = zext i32 %9 to i64
  %11 = call noalias i8* @calloc(i64 noundef %10, i64 noundef 1) #6
  store i8* %11, i8** %6, align 8
  %12 = load i8*, i8** %6, align 8
  %13 = icmp ne i8* %12, null
  br i1 %13, label %14, label %15

14:                                               ; preds = %2
  br label %16

15:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @__PRETTY_FUNCTION__.init_surface, i64 0, i64 0)) #7
  unreachable

16:                                               ; preds = %14
  %17 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 0
  %18 = load i8*, i8** %6, align 8
  store i8* %18, i8** %17, align 8
  %19 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 1
  %20 = load i32, i32* %5, align 4
  store i32 %20, i32* %19, align 8
  %21 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 2
  %22 = load i32, i32* %4, align 4
  store i32 %22, i32* %21, align 4
  %23 = bitcast %struct.surface_t* %3 to { i8*, i64 }*
  %24 = load { i8*, i64 }, { i8*, i64 }* %23, align 8
  ret { i8*, i64 } %24
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64 noundef, i64 noundef) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local zeroext i8 @at(i8* %0, i64 %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca %struct.surface_t, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = bitcast %struct.surface_t* %5 to { i8*, i64 }*
  %9 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %8, i32 0, i32 0
  store i8* %0, i8** %9, align 8
  %10 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %8, i32 0, i32 1
  store i64 %1, i64* %10, align 8
  store i32 %2, i32* %6, align 4
  store i32 %3, i32* %7, align 4
  %11 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %5, i32 0, i32 0
  %12 = load i8*, i8** %11, align 8
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %6, align 4
  %15 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %5, i32 0, i32 1
  %16 = load i32, i32* %15, align 8
  %17 = mul i32 %14, %16
  %18 = add i32 %13, %17
  %19 = zext i32 %18 to i64
  %20 = getelementptr inbounds i8, i8* %12, i64 %19
  %21 = load i8, i8* %20, align 1
  ret i8 %21
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @set(i8* %0, i64 %1, i32 noundef %2, i32 noundef %3, i8 noundef zeroext %4) #0 {
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %11 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 0
  store i8* %0, i8** %11, align 8
  %12 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 1
  store i64 %1, i64* %12, align 8
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  store i8 %4, i8* %9, align 1
  %13 = load i8, i8* %9, align 1
  %14 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 0
  %15 = load i8*, i8** %14, align 8
  %16 = load i32, i32* %8, align 4
  %17 = load i32, i32* %7, align 4
  %18 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 1
  %19 = load i32, i32* %18, align 8
  %20 = mul i32 %17, %19
  %21 = add i32 %16, %20
  %22 = zext i32 %21 to i64
  %23 = getelementptr inbounds i8, i8* %15, i64 %22
  store i8 %13, i8* %23, align 1
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @clear(i8* %0, i64 %1) #0 {
  %3 = alloca %struct.surface_t, align 8
  %4 = bitcast %struct.surface_t* %3 to { i8*, i64 }*
  %5 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
  store i8* %0, i8** %5, align 8
  %6 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 1
  store i64 %1, i64* %6, align 8
  %7 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 0
  %8 = load i8*, i8** %7, align 8
  %9 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 2
  %10 = load i32, i32* %9, align 4
  %11 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 1
  %12 = load i32, i32* %11, align 8
  %13 = mul i32 %10, %12
  %14 = zext i32 %13 to i64
  %15 = mul i64 %14, 1
  call void @llvm.memset.p0i8.i64(i8* align 1 %8, i8 0, i64 %15, i1 false)
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @delete_surface(i8* %0, i64 %1) #0 {
  %3 = alloca %struct.surface_t, align 8
  %4 = bitcast %struct.surface_t* %3 to { i8*, i64 }*
  %5 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
  store i8* %0, i8** %5, align 8
  %6 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 1
  store i64 %1, i64* %6, align 8
  %7 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 0
  %8 = load i8*, i8** %7, align 8
  call void @free(i8* noundef %8) #6
  ret void
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init_world(i8* %0, i64 %1, i32 noundef %2) #0 {
  %4 = alloca %struct.surface_t, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  %9 = bitcast %struct.surface_t* %4 to { i8*, i64 }*
  %10 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 0
  store i8* %0, i8** %10, align 8
  %11 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 1
  store i64 %1, i64* %11, align 8
  store i32 %2, i32* %5, align 4
  %12 = call i64 @time(i64* noundef null) #6
  %13 = trunc i64 %12 to i32
  call void @srand(i32 noundef %13) #6
  store i32 0, i32* %6, align 4
  br label %14

14:                                               ; preds = %48, %3
  %15 = load i32, i32* %6, align 4
  %16 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %4, i32 0, i32 2
  %17 = load i32, i32* %16, align 4
  %18 = icmp ult i32 %15, %17
  br i1 %18, label %19, label %51

19:                                               ; preds = %14
  store i32 0, i32* %7, align 4
  br label %20

20:                                               ; preds = %44, %19
  %21 = load i32, i32* %7, align 4
  %22 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %4, i32 0, i32 1
  %23 = load i32, i32* %22, align 8
  %24 = icmp ult i32 %21, %23
  br i1 %24, label %25, label %47

25:                                               ; preds = %20
  %26 = load i32, i32* %5, align 4
  switch i32 %26, label %35 [
    i32 0, label %27
    i32 1, label %31
  ]

27:                                               ; preds = %25
  %28 = call i32 @rand() #6
  %29 = srem i32 %28, 2
  %30 = trunc i32 %29 to i8
  store i8 %30, i8* %8, align 1
  br label %35

31:                                               ; preds = %25
  %32 = call i32 @rand() #6
  %33 = srem i32 %32, 8
  %34 = trunc i32 %33 to i8
  store i8 %34, i8* %8, align 1
  br label %35

35:                                               ; preds = %25, %31, %27
  %36 = load i32, i32* %6, align 4
  %37 = load i32, i32* %7, align 4
  %38 = load i8, i8* %8, align 1
  %39 = bitcast %struct.surface_t* %4 to { i8*, i64 }*
  %40 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 0
  %41 = load i8*, i8** %40, align 8
  %42 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
  %43 = load i64, i64* %42, align 8
  call void @set(i8* %41, i64 %43, i32 noundef %36, i32 noundef %37, i8 noundef zeroext %38)
  br label %44

44:                                               ; preds = %35
  %45 = load i32, i32* %7, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, i32* %7, align 4
  br label %20, !llvm.loop !6

47:                                               ; preds = %20
  br label %48

48:                                               ; preds = %47
  %49 = load i32, i32* %6, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %6, align 4
  br label %14, !llvm.loop !8

51:                                               ; preds = %14
  ret void
}

; Function Attrs: nounwind
declare void @srand(i32 noundef) #1

; Function Attrs: nounwind
declare i64 @time(i64* noundef) #1

; Function Attrs: nounwind
declare i32 @rand() #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @update(i8* %0, i64 %1, i8* %2, i64 %3, i32 noundef %4) #0 {
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca %struct.surface_t, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8 (i8*, i64, i32, i32)*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i8, align 1
  %13 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %14 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 0
  store i8* %0, i8** %14, align 8
  %15 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 1
  store i64 %1, i64* %15, align 8
  %16 = bitcast %struct.surface_t* %7 to { i8*, i64 }*
  %17 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 0
  store i8* %2, i8** %17, align 8
  %18 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 1
  store i64 %3, i64* %18, align 8
  store i32 %4, i32* %8, align 4
  store i8 (i8*, i64, i32, i32)* null, i8 (i8*, i64, i32, i32)** %9, align 8
  %19 = load i32, i32* %8, align 4
  switch i32 %19, label %22 [
    i32 0, label %20
    i32 1, label %21
  ]

20:                                               ; preds = %5
  store i8 (i8*, i64, i32, i32)* @classic_rule, i8 (i8*, i64, i32, i32)** %9, align 8
  br label %22

21:                                               ; preds = %5
  store i8 (i8*, i64, i32, i32)* @cyclic_rule, i8 (i8*, i64, i32, i32)** %9, align 8
  br label %22

22:                                               ; preds = %5, %21, %20
  store i32 0, i32* %10, align 4
  br label %23

23:                                               ; preds = %56, %22
  %24 = load i32, i32* %10, align 4
  %25 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 2
  %26 = load i32, i32* %25, align 4
  %27 = icmp ult i32 %24, %26
  br i1 %27, label %28, label %59

28:                                               ; preds = %23
  store i32 0, i32* %11, align 4
  br label %29

29:                                               ; preds = %52, %28
  %30 = load i32, i32* %11, align 4
  %31 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 1
  %32 = load i32, i32* %31, align 8
  %33 = icmp ult i32 %30, %32
  br i1 %33, label %34, label %55

34:                                               ; preds = %29
  %35 = load i8 (i8*, i64, i32, i32)*, i8 (i8*, i64, i32, i32)** %9, align 8
  %36 = load i32, i32* %10, align 4
  %37 = load i32, i32* %11, align 4
  %38 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %39 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %38, i32 0, i32 0
  %40 = load i8*, i8** %39, align 8
  %41 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %38, i32 0, i32 1
  %42 = load i64, i64* %41, align 8
  %43 = call zeroext i8 %35(i8* %40, i64 %42, i32 noundef %36, i32 noundef %37)
  store i8 %43, i8* %12, align 1
  %44 = load i32, i32* %10, align 4
  %45 = load i32, i32* %11, align 4
  %46 = load i8, i8* %12, align 1
  %47 = bitcast %struct.surface_t* %7 to { i8*, i64 }*
  %48 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %47, i32 0, i32 0
  %49 = load i8*, i8** %48, align 8
  %50 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %47, i32 0, i32 1
  %51 = load i64, i64* %50, align 8
  call void @set(i8* %49, i64 %51, i32 noundef %44, i32 noundef %45, i8 noundef zeroext %46)
  br label %52

52:                                               ; preds = %34
  %53 = load i32, i32* %11, align 4
  %54 = add nsw i32 %53, 1
  store i32 %54, i32* %11, align 4
  br label %29, !llvm.loop !9

55:                                               ; preds = %29
  br label %56

56:                                               ; preds = %55
  %57 = load i32, i32* %10, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %10, align 4
  br label %23, !llvm.loop !10

59:                                               ; preds = %23
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i8 @classic_rule(i8* %0, i64 %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca i8, align 1
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %11 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 0
  store i8* %0, i8** %11, align 8
  %12 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 1
  store i64 %1, i64* %12, align 8
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %8, align 4
  %15 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %16 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %15, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %15, i32 0, i32 1
  %19 = load i64, i64* %18, align 8
  %20 = call i32 @neighbors_count(i8* %17, i64 %19, i32 noundef %13, i32 noundef %14, i8 noundef zeroext 1)
  store i32 %20, i32* %9, align 4
  %21 = load i32, i32* %7, align 4
  %22 = load i32, i32* %8, align 4
  %23 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %24 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %23, i32 0, i32 0
  %25 = load i8*, i8** %24, align 8
  %26 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %23, i32 0, i32 1
  %27 = load i64, i64* %26, align 8
  %28 = call zeroext i8 @at(i8* %25, i64 %27, i32 noundef %21, i32 noundef %22)
  %29 = zext i8 %28 to i32
  %30 = icmp eq i32 0, %29
  br i1 %30, label %31, label %36

31:                                               ; preds = %4
  %32 = load i32, i32* %9, align 4
  %33 = icmp eq i32 %32, 3
  br i1 %33, label %34, label %35

34:                                               ; preds = %31
  store i8 1, i8* %5, align 1
  br label %55

35:                                               ; preds = %31
  br label %36

36:                                               ; preds = %35, %4
  %37 = load i32, i32* %7, align 4
  %38 = load i32, i32* %8, align 4
  %39 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %40 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 0
  %41 = load i8*, i8** %40, align 8
  %42 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
  %43 = load i64, i64* %42, align 8
  %44 = call zeroext i8 @at(i8* %41, i64 %43, i32 noundef %37, i32 noundef %38)
  %45 = zext i8 %44 to i32
  %46 = icmp eq i32 1, %45
  br i1 %46, label %47, label %55

47:                                               ; preds = %36
  %48 = load i32, i32* %9, align 4
  %49 = icmp sgt i32 %48, 3
  br i1 %49, label %53, label %50

50:                                               ; preds = %47
  %51 = load i32, i32* %9, align 4
  %52 = icmp slt i32 %51, 2
  br i1 %52, label %53, label %54

53:                                               ; preds = %50, %47
  store i8 0, i8* %5, align 1
  br label %55

54:                                               ; preds = %50
  store i8 1, i8* %5, align 1
  br label %55

55:                                               ; preds = %34, %53, %54, %36
  %56 = load i8, i8* %5, align 1
  ret i8 %56
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i8 @cyclic_rule(i8* %0, i64 %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca i8, align 1
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = alloca i8, align 1
  %11 = alloca i32, align 4
  %12 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %13 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 0
  store i8* %0, i8** %13, align 8
  %14 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 1
  store i64 %1, i64* %14, align 8
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  %15 = load i32, i32* %7, align 4
  %16 = load i32, i32* %8, align 4
  %17 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %18 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %17, i32 0, i32 0
  %19 = load i8*, i8** %18, align 8
  %20 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %17, i32 0, i32 1
  %21 = load i64, i64* %20, align 8
  %22 = call zeroext i8 @at(i8* %19, i64 %21, i32 noundef %15, i32 noundef %16)
  store i8 %22, i8* %9, align 1
  %23 = load i8, i8* %9, align 1
  %24 = zext i8 %23 to i32
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %4
  br label %31

27:                                               ; preds = %4
  %28 = load i8, i8* %9, align 1
  %29 = zext i8 %28 to i32
  %30 = sub nsw i32 %29, 1
  br label %31

31:                                               ; preds = %27, %26
  %32 = phi i32 [ 7, %26 ], [ %30, %27 ]
  %33 = trunc i32 %32 to i8
  store i8 %33, i8* %10, align 1
  %34 = load i32, i32* %7, align 4
  %35 = load i32, i32* %8, align 4
  %36 = load i8, i8* %10, align 1
  %37 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %38 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %37, i32 0, i32 0
  %39 = load i8*, i8** %38, align 8
  %40 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %37, i32 0, i32 1
  %41 = load i64, i64* %40, align 8
  %42 = call i32 @neighbors_count(i8* %39, i64 %41, i32 noundef %34, i32 noundef %35, i8 noundef zeroext %36)
  store i32 %42, i32* %11, align 4
  %43 = load i32, i32* %11, align 4
  %44 = icmp sge i32 %43, 2
  br i1 %44, label %45, label %47

45:                                               ; preds = %31
  %46 = load i8, i8* %10, align 1
  store i8 %46, i8* %5, align 1
  br label %49

47:                                               ; preds = %31
  %48 = load i8, i8* %9, align 1
  store i8 %48, i8* %5, align 1
  br label %49

49:                                               ; preds = %47, %45
  %50 = load i8, i8* %5, align 1
  ret i8 %50
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @swap(%struct.surface_t* noundef %0, %struct.surface_t* noundef %1) #0 {
  %3 = alloca %struct.surface_t*, align 8
  %4 = alloca %struct.surface_t*, align 8
  %5 = alloca %struct.surface_t, align 8
  store %struct.surface_t* %0, %struct.surface_t** %3, align 8
  store %struct.surface_t* %1, %struct.surface_t** %4, align 8
  %6 = load %struct.surface_t*, %struct.surface_t** %3, align 8
  %7 = bitcast %struct.surface_t* %5 to i8*
  %8 = bitcast %struct.surface_t* %6 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %7, i8* align 8 %8, i64 16, i1 false)
  %9 = load %struct.surface_t*, %struct.surface_t** %3, align 8
  %10 = load %struct.surface_t*, %struct.surface_t** %4, align 8
  %11 = bitcast %struct.surface_t* %9 to i8*
  %12 = bitcast %struct.surface_t* %10 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %11, i8* align 8 %12, i64 16, i1 false)
  %13 = load %struct.surface_t*, %struct.surface_t** %4, align 8
  %14 = bitcast %struct.surface_t* %13 to i8*
  %15 = bitcast %struct.surface_t* %5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %14, i8* align 8 %15, i64 16, i1 false)
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @draw(i8* %0, i64 %1) #0 {
  %3 = alloca %struct.surface_t, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = bitcast %struct.surface_t* %3 to { i8*, i64 }*
  %7 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 0
  store i8* %0, i8** %7, align 8
  %8 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 1
  store i64 %1, i64* %8, align 8
  store i32 0, i32* %4, align 4
  br label %9

9:                                                ; preds = %35, %2
  %10 = load i32, i32* %4, align 4
  %11 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 2
  %12 = load i32, i32* %11, align 4
  %13 = icmp ult i32 %10, %12
  br i1 %13, label %14, label %38

14:                                               ; preds = %9
  store i32 0, i32* %5, align 4
  br label %15

15:                                               ; preds = %31, %14
  %16 = load i32, i32* %5, align 4
  %17 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %3, i32 0, i32 1
  %18 = load i32, i32* %17, align 8
  %19 = icmp ult i32 %16, %18
  br i1 %19, label %20, label %34

20:                                               ; preds = %15
  %21 = load i32, i32* %4, align 4
  %22 = load i32, i32* %5, align 4
  %23 = load i32, i32* %4, align 4
  %24 = load i32, i32* %5, align 4
  %25 = bitcast %struct.surface_t* %3 to { i8*, i64 }*
  %26 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %25, i32 0, i32 0
  %27 = load i8*, i8** %26, align 8
  %28 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %25, i32 0, i32 1
  %29 = load i64, i64* %28, align 8
  %30 = call zeroext i8 @at(i8* %27, i64 %29, i32 noundef %23, i32 noundef %24)
  call void @dr_put_pixel(i32 noundef %21, i32 noundef %22, i8 noundef zeroext %30)
  br label %31

31:                                               ; preds = %20
  %32 = load i32, i32* %5, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %5, align 4
  br label %15, !llvm.loop !11

34:                                               ; preds = %15
  br label %35

35:                                               ; preds = %34
  %36 = load i32, i32* %4, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, i32* %4, align 4
  br label %9, !llvm.loop !12

38:                                               ; preds = %9
  call void (...) @dr_flush()
  ret void
}

declare void @dr_put_pixel(i32 noundef, i32 noundef, i8 noundef zeroext) #5

declare void @dr_flush(...) #5

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca %struct.surface_t, align 8
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  call void @dr_init_window(i32 noundef 1000, i32 noundef 800)
  %9 = call { i8*, i64 } @init_surface(i32 noundef 1000, i32 noundef 800)
  %10 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %11 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 0
  %12 = extractvalue { i8*, i64 } %9, 0
  store i8* %12, i8** %11, align 8
  %13 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 1
  %14 = extractvalue { i8*, i64 } %9, 1
  store i64 %14, i64* %13, align 8
  %15 = call { i8*, i64 } @init_surface(i32 noundef 1000, i32 noundef 800)
  %16 = bitcast %struct.surface_t* %7 to { i8*, i64 }*
  %17 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 0
  %18 = extractvalue { i8*, i64 } %15, 0
  store i8* %18, i8** %17, align 8
  %19 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 1
  %20 = extractvalue { i8*, i64 } %15, 1
  store i64 %20, i64* %19, align 8
  store i32 1, i32* %8, align 4
  %21 = load i32, i32* %8, align 4
  %22 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %23 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %22, i32 0, i32 0
  %24 = load i8*, i8** %23, align 8
  %25 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %22, i32 0, i32 1
  %26 = load i64, i64* %25, align 8
  call void @init_world(i8* %24, i64 %26, i32 noundef %21)
  br label %27

27:                                               ; preds = %30, %2
  %28 = call zeroext i8 (...) @dr_window_is_open()
  %29 = icmp ne i8 %28, 0
  br i1 %29, label %30, label %47

30:                                               ; preds = %27
  call void (...) @dr_clear()
  %31 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %32 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 0
  %33 = load i8*, i8** %32, align 8
  %34 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 1
  %35 = load i64, i64* %34, align 8
  call void @draw(i8* %33, i64 %35)
  %36 = load i32, i32* %8, align 4
  %37 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %38 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %37, i32 0, i32 0
  %39 = load i8*, i8** %38, align 8
  %40 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %37, i32 0, i32 1
  %41 = load i64, i64* %40, align 8
  %42 = bitcast %struct.surface_t* %7 to { i8*, i64 }*
  %43 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %42, i32 0, i32 0
  %44 = load i8*, i8** %43, align 8
  %45 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %42, i32 0, i32 1
  %46 = load i64, i64* %45, align 8
  call void @update(i8* %39, i64 %41, i8* %44, i64 %46, i32 noundef %36)
  call void (...) @dr_process_events()
  call void @swap(%struct.surface_t* noundef %6, %struct.surface_t* noundef %7)
  br label %27, !llvm.loop !13

47:                                               ; preds = %27
  %48 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %49 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %48, i32 0, i32 0
  %50 = load i8*, i8** %49, align 8
  %51 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %48, i32 0, i32 1
  %52 = load i64, i64* %51, align 8
  call void @delete_surface(i8* %50, i64 %52)
  %53 = bitcast %struct.surface_t* %7 to { i8*, i64 }*
  %54 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %53, i32 0, i32 0
  %55 = load i8*, i8** %54, align 8
  %56 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %53, i32 0, i32 1
  %57 = load i64, i64* %56, align 8
  call void @delete_surface(i8* %55, i64 %57)
  %58 = load i32, i32* %3, align 4
  ret i32 %58
}

declare void @dr_init_window(i32 noundef, i32 noundef) #5

declare zeroext i8 @dr_window_is_open(...) #5

declare void @dr_clear(...) #5

declare void @dr_process_events(...) #5

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @neighbors_count(i8* %0, i64 %1, i32 noundef %2, i32 noundef %3, i8 noundef zeroext %4) #0 {
  %6 = alloca %struct.surface_t, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %14 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 0
  store i8* %0, i8** %14, align 8
  %15 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 1
  store i64 %1, i64* %15, align 8
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  store i8 %4, i8* %9, align 1
  store i32 0, i32* %10, align 4
  %16 = load i32, i32* %7, align 4
  %17 = sub nsw i32 %16, 1
  store i32 %17, i32* %11, align 4
  br label %18

18:                                               ; preds = %78, %5
  %19 = load i32, i32* %11, align 4
  %20 = load i32, i32* %7, align 4
  %21 = add nsw i32 %20, 1
  %22 = icmp sle i32 %19, %21
  br i1 %22, label %23, label %81

23:                                               ; preds = %18
  %24 = load i32, i32* %8, align 4
  %25 = sub nsw i32 %24, 1
  store i32 %25, i32* %12, align 4
  br label %26

26:                                               ; preds = %74, %23
  %27 = load i32, i32* %12, align 4
  %28 = load i32, i32* %8, align 4
  %29 = add nsw i32 %28, 1
  %30 = icmp sle i32 %27, %29
  br i1 %30, label %31, label %77

31:                                               ; preds = %26
  %32 = load i32, i32* %11, align 4
  %33 = load i32, i32* %7, align 4
  %34 = icmp eq i32 %32, %33
  br i1 %34, label %35, label %40

35:                                               ; preds = %31
  %36 = load i32, i32* %12, align 4
  %37 = load i32, i32* %8, align 4
  %38 = icmp eq i32 %36, %37
  br i1 %38, label %39, label %40

39:                                               ; preds = %35
  br label %74

40:                                               ; preds = %35, %31
  %41 = load i32, i32* %11, align 4
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %56, label %43

43:                                               ; preds = %40
  %44 = load i32, i32* %11, align 4
  %45 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 2
  %46 = load i32, i32* %45, align 4
  %47 = icmp uge i32 %44, %46
  br i1 %47, label %56, label %48

48:                                               ; preds = %43
  %49 = load i32, i32* %12, align 4
  %50 = icmp slt i32 %49, 0
  br i1 %50, label %56, label %51

51:                                               ; preds = %48
  %52 = load i32, i32* %12, align 4
  %53 = getelementptr inbounds %struct.surface_t, %struct.surface_t* %6, i32 0, i32 1
  %54 = load i32, i32* %53, align 8
  %55 = icmp uge i32 %52, %54
  br i1 %55, label %56, label %57

56:                                               ; preds = %51, %48, %43, %40
  br label %74

57:                                               ; preds = %51
  %58 = load i8, i8* %9, align 1
  %59 = zext i8 %58 to i32
  %60 = load i32, i32* %11, align 4
  %61 = load i32, i32* %12, align 4
  %62 = bitcast %struct.surface_t* %6 to { i8*, i64 }*
  %63 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %62, i32 0, i32 0
  %64 = load i8*, i8** %63, align 8
  %65 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %62, i32 0, i32 1
  %66 = load i64, i64* %65, align 8
  %67 = call zeroext i8 @at(i8* %64, i64 %66, i32 noundef %60, i32 noundef %61)
  %68 = zext i8 %67 to i32
  %69 = icmp eq i32 %59, %68
  br i1 %69, label %70, label %73

70:                                               ; preds = %57
  %71 = load i32, i32* %10, align 4
  %72 = add nsw i32 %71, 1
  store i32 %72, i32* %10, align 4
  br label %73

73:                                               ; preds = %70, %57
  br label %74

74:                                               ; preds = %73, %56, %39
  %75 = load i32, i32* %12, align 4
  %76 = add nsw i32 %75, 1
  store i32 %76, i32* %12, align 4
  br label %26, !llvm.loop !14

77:                                               ; preds = %26
  br label %78

78:                                               ; preds = %77
  %79 = load i32, i32* %11, align 4
  %80 = add nsw i32 %79, 1
  store i32 %80, i32* %11, align 4
  br label %18, !llvm.loop !15

81:                                               ; preds = %18
  %82 = load i32, i32* %10, align 4
  ret i32 %82
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly nofree nounwind willreturn }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
