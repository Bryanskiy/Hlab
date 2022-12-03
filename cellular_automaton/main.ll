; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@current_surf = dso_local global [240000 x i32] zeroinitializer, align 16
@tmp_surf = dso_local global [240000 x i32] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init_world() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %3

3:                                                ; preds = %23, %0
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 600
  br i1 %5, label %6, label %26

6:                                                ; preds = %3
  store i32 0, i32* %2, align 4
  br label %7

7:                                                ; preds = %19, %6
  %8 = load i32, i32* %2, align 4
  %9 = icmp slt i32 %8, 400
  br i1 %9, label %10, label %22

10:                                               ; preds = %7
  %11 = call i32 (...) @dr_rand()
  %12 = srem i32 %11, 16
  %13 = load i32, i32* %1, align 4
  %14 = load i32, i32* %2, align 4
  %15 = mul nsw i32 %14, 600
  %16 = add nsw i32 %13, %15
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %17
  store i32 %12, i32* %18, align 4
  br label %19

19:                                               ; preds = %10
  %20 = load i32, i32* %2, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, i32* %2, align 4
  br label %7, !llvm.loop !6

22:                                               ; preds = %7
  br label %23

23:                                               ; preds = %22
  %24 = load i32, i32* %1, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %1, align 4
  br label %3, !llvm.loop !8

26:                                               ; preds = %3
  ret void
}

declare i32 @dr_rand(...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @update() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %7

7:                                                ; preds = %52, %0
  %8 = load i32, i32* %1, align 4
  %9 = icmp slt i32 %8, 600
  br i1 %9, label %10, label %55

10:                                               ; preds = %7
  store i32 0, i32* %2, align 4
  br label %11

11:                                               ; preds = %48, %10
  %12 = load i32, i32* %2, align 4
  %13 = icmp slt i32 %12, 400
  br i1 %13, label %14, label %51

14:                                               ; preds = %11
  %15 = load i32, i32* %1, align 4
  %16 = load i32, i32* %2, align 4
  %17 = mul nsw i32 %16, 600
  %18 = add nsw i32 %15, %17
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %19
  %21 = load i32, i32* %20, align 4
  store i32 %21, i32* %3, align 4
  %22 = load i32, i32* %3, align 4
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %25

24:                                               ; preds = %14
  br label %28

25:                                               ; preds = %14
  %26 = load i32, i32* %3, align 4
  %27 = sub nsw i32 %26, 1
  br label %28

28:                                               ; preds = %25, %24
  %29 = phi i32 [ 15, %24 ], [ %27, %25 ]
  store i32 %29, i32* %4, align 4
  %30 = load i32, i32* %1, align 4
  %31 = load i32, i32* %2, align 4
  %32 = load i32, i32* %4, align 4
  %33 = call i32 @neighbors_count(i32 noundef %30, i32 noundef %31, i32 noundef %32)
  store i32 %33, i32* %5, align 4
  %34 = load i32, i32* %5, align 4
  %35 = icmp sge i32 %34, 1
  br i1 %35, label %36, label %38

36:                                               ; preds = %28
  %37 = load i32, i32* %4, align 4
  store i32 %37, i32* %6, align 4
  br label %40

38:                                               ; preds = %28
  %39 = load i32, i32* %3, align 4
  store i32 %39, i32* %6, align 4
  br label %40

40:                                               ; preds = %38, %36
  %41 = load i32, i32* %6, align 4
  %42 = load i32, i32* %1, align 4
  %43 = load i32, i32* %2, align 4
  %44 = mul nsw i32 %43, 600
  %45 = add nsw i32 %42, %44
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds [240000 x i32], [240000 x i32]* @tmp_surf, i64 0, i64 %46
  store i32 %41, i32* %47, align 4
  br label %48

48:                                               ; preds = %40
  %49 = load i32, i32* %2, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %2, align 4
  br label %11, !llvm.loop !9

51:                                               ; preds = %11
  br label %52

52:                                               ; preds = %51
  %53 = load i32, i32* %1, align 4
  %54 = add nsw i32 %53, 1
  store i32 %54, i32* %1, align 4
  br label %7, !llvm.loop !10

55:                                               ; preds = %7
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @neighbors_count(i32 noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 0, i32* %7, align 4
  %10 = load i32, i32* %4, align 4
  %11 = sub nsw i32 %10, 1
  store i32 %11, i32* %8, align 4
  br label %12

12:                                               ; preds = %65, %3
  %13 = load i32, i32* %8, align 4
  %14 = load i32, i32* %4, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sle i32 %13, %15
  br i1 %16, label %17, label %68

17:                                               ; preds = %12
  %18 = load i32, i32* %5, align 4
  %19 = sub nsw i32 %18, 1
  store i32 %19, i32* %9, align 4
  br label %20

20:                                               ; preds = %61, %17
  %21 = load i32, i32* %9, align 4
  %22 = load i32, i32* %5, align 4
  %23 = add nsw i32 %22, 1
  %24 = icmp sle i32 %21, %23
  br i1 %24, label %25, label %64

25:                                               ; preds = %20
  %26 = load i32, i32* %8, align 4
  %27 = load i32, i32* %4, align 4
  %28 = icmp eq i32 %26, %27
  br i1 %28, label %29, label %34

29:                                               ; preds = %25
  %30 = load i32, i32* %9, align 4
  %31 = load i32, i32* %5, align 4
  %32 = icmp eq i32 %30, %31
  br i1 %32, label %33, label %34

33:                                               ; preds = %29
  br label %61

34:                                               ; preds = %29, %25
  %35 = load i32, i32* %8, align 4
  %36 = icmp slt i32 %35, 0
  br i1 %36, label %46, label %37

37:                                               ; preds = %34
  %38 = load i32, i32* %8, align 4
  %39 = icmp sge i32 %38, 600
  br i1 %39, label %46, label %40

40:                                               ; preds = %37
  %41 = load i32, i32* %9, align 4
  %42 = icmp slt i32 %41, 0
  br i1 %42, label %46, label %43

43:                                               ; preds = %40
  %44 = load i32, i32* %9, align 4
  %45 = icmp sge i32 %44, 400
  br i1 %45, label %46, label %47

46:                                               ; preds = %43, %40, %37, %34
  br label %61

47:                                               ; preds = %43
  %48 = load i32, i32* %8, align 4
  %49 = load i32, i32* %9, align 4
  %50 = mul nsw i32 %49, 600
  %51 = add nsw i32 %48, %50
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %52
  %54 = load i32, i32* %53, align 4
  %55 = load i32, i32* %6, align 4
  %56 = icmp eq i32 %54, %55
  br i1 %56, label %57, label %60

57:                                               ; preds = %47
  %58 = load i32, i32* %7, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %7, align 4
  br label %60

60:                                               ; preds = %57, %47
  br label %61

61:                                               ; preds = %60, %46, %33
  %62 = load i32, i32* %9, align 4
  %63 = add nsw i32 %62, 1
  store i32 %63, i32* %9, align 4
  br label %20, !llvm.loop !11

64:                                               ; preds = %20
  br label %65

65:                                               ; preds = %64
  %66 = load i32, i32* %8, align 4
  %67 = add nsw i32 %66, 1
  store i32 %67, i32* %8, align 4
  br label %12, !llvm.loop !12

68:                                               ; preds = %12
  %69 = load i32, i32* %7, align 4
  ret i32 %69
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @swap() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %4

4:                                                ; preds = %43, %0
  %5 = load i32, i32* %1, align 4
  %6 = icmp slt i32 %5, 600
  br i1 %6, label %7, label %46

7:                                                ; preds = %4
  store i32 0, i32* %2, align 4
  br label %8

8:                                                ; preds = %39, %7
  %9 = load i32, i32* %2, align 4
  %10 = icmp slt i32 %9, 400
  br i1 %10, label %11, label %42

11:                                               ; preds = %8
  %12 = load i32, i32* %1, align 4
  %13 = load i32, i32* %2, align 4
  %14 = mul nsw i32 %13, 600
  %15 = add nsw i32 %12, %14
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %16
  %18 = load i32, i32* %17, align 4
  store i32 %18, i32* %3, align 4
  %19 = load i32, i32* %1, align 4
  %20 = load i32, i32* %2, align 4
  %21 = mul nsw i32 %20, 600
  %22 = add nsw i32 %19, %21
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds [240000 x i32], [240000 x i32]* @tmp_surf, i64 0, i64 %23
  %25 = load i32, i32* %24, align 4
  %26 = load i32, i32* %1, align 4
  %27 = load i32, i32* %2, align 4
  %28 = mul nsw i32 %27, 600
  %29 = add nsw i32 %26, %28
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %30
  store i32 %25, i32* %31, align 4
  %32 = load i32, i32* %3, align 4
  %33 = load i32, i32* %1, align 4
  %34 = load i32, i32* %2, align 4
  %35 = mul nsw i32 %34, 600
  %36 = add nsw i32 %33, %35
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds [240000 x i32], [240000 x i32]* @tmp_surf, i64 0, i64 %37
  store i32 %32, i32* %38, align 4
  br label %39

39:                                               ; preds = %11
  %40 = load i32, i32* %2, align 4
  %41 = add nsw i32 %40, 1
  store i32 %41, i32* %2, align 4
  br label %8, !llvm.loop !13

42:                                               ; preds = %8
  br label %43

43:                                               ; preds = %42
  %44 = load i32, i32* %1, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %1, align 4
  br label %4, !llvm.loop !14

46:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @draw() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %3

3:                                                ; preds = %24, %0
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 600
  br i1 %5, label %6, label %27

6:                                                ; preds = %3
  store i32 0, i32* %2, align 4
  br label %7

7:                                                ; preds = %20, %6
  %8 = load i32, i32* %2, align 4
  %9 = icmp slt i32 %8, 400
  br i1 %9, label %10, label %23

10:                                               ; preds = %7
  %11 = load i32, i32* %1, align 4
  %12 = load i32, i32* %2, align 4
  %13 = load i32, i32* %1, align 4
  %14 = load i32, i32* %2, align 4
  %15 = mul nsw i32 %14, 600
  %16 = add nsw i32 %13, %15
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [240000 x i32], [240000 x i32]* @current_surf, i64 0, i64 %17
  %19 = load i32, i32* %18, align 4
  call void @dr_put_pixel(i32 noundef %11, i32 noundef %12, i32 noundef %19)
  br label %20

20:                                               ; preds = %10
  %21 = load i32, i32* %2, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, i32* %2, align 4
  br label %7, !llvm.loop !15

23:                                               ; preds = %7
  br label %24

24:                                               ; preds = %23
  %25 = load i32, i32* %1, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %1, align 4
  br label %3, !llvm.loop !16

27:                                               ; preds = %3
  call void (...) @dr_flush()
  ret void
}

declare void @dr_put_pixel(i32 noundef, i32 noundef, i32 noundef) #1

declare void @dr_flush(...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @dr_init_window(i32 noundef 600, i32 noundef 400)
  call void @init_world()
  br label %2

2:                                                ; preds = %0, %2
  call void @draw()
  call void @update()
  call void @swap()
  br label %2
}

declare void @dr_init_window(i32 noundef, i32 noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
!16 = distinct !{!16, !7}
