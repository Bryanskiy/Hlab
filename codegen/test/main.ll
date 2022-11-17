 
; ModuleID = 'main.c'
source_filename = "main.c"

@current_surf = dso_local global [600 x [400 x i32]] zeroinitializer, align 16
@tmp_surf = dso_local global [600 x [400 x i32]] zeroinitializer, align 16

define void @main() {
entry:
  %0 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  call void @dr_init_window(i32 600, i32 400)
  call void @init_world()
  br label %loop

loop:                                             ; preds = %loop, %entry
  call void @draw()
  call void @update()
  call void @swap()
  br label %loop
}

define void @init_world() {
"0":
  %0 = alloca i32, align 4
  %1 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  br label %"3"

"3":                                              ; preds = %"23", %"0"
  %2 = load i32, i32* %0, align 4
  %3 = icmp slt i32 %2, 600
  br i1 %3, label %"6", label %"26"

"6":                                              ; preds = %"3"
  store i32 0, i32* %1, align 4
  br label %"7"

"7":                                              ; preds = %"19", %"6"
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 400
  br i1 %5, label %"10", label %"22"

"10":                                             ; preds = %"7"
  %6 = call i32 @dr_rand()
  %7 = srem i32 %6, 16
  %8 = load i32, i32* %0, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %9
  %11 = load i32, i32* %1, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr [400 x i32], [400 x i32]* %10, i64 0, i64 %12
  store i32 %7, i32* %13, align 4
  br label %"19"

"19":                                             ; preds = %"10"
  %14 = load i32, i32* %1, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, i32* %1, align 4
  br label %"7"

"22":                                             ; preds = %"7"
  br label %"23"

"23":                                             ; preds = %"22"
  %16 = load i32, i32* %0, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* %0, align 4
  br label %"3"

"26":                                             ; preds = %"3"
  ret void
}

define void @draw() {
"0":
  %0 = alloca i32, align 4
  %1 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  br label %"3"

"3":                                              ; preds = %"24", %"0"
  %2 = load i32, i32* %0, align 4
  %3 = icmp slt i32 %2, 600
  br i1 %3, label %"6", label %"27"

"6":                                              ; preds = %"3"
  store i32 0, i32* %1, align 4
  br label %"7"

"7":                                              ; preds = %"20", %"6"
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 400
  br i1 %5, label %"10", label %"23"

"10":                                             ; preds = %"7"
  %6 = load i32, i32* %0, align 4
  %7 = load i32, i32* %1, align 4
  %8 = load i32, i32* %0, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %9
  %11 = load i32, i32* %1, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr [400 x i32], [400 x i32]* %10, i64 0, i64 %12
  %14 = load i32, i32* %13, align 4
  call void @dr_put_pixel(i32 %6, i32 %7, i32 %14)
  br label %"20"

"20":                                             ; preds = %"10"
  %15 = load i32, i32* %1, align 4
  %16 = add nsw i32 %15, 1
  store i32 %16, i32* %1, align 4
  br label %"7"

"23":                                             ; preds = %"7"
  br label %"24"

"24":                                             ; preds = %"23"
  %17 = load i32, i32* %0, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %0, align 4
  br label %"3"

"27":                                             ; preds = %"3"
  call void @dr_flush()
  ret void
}

define void @update() {
"0":
  %0 = alloca i32, align 4
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  br label %"7"

"7":                                              ; preds = %"52", %"0"
  %6 = load i32, i32* %0, align 4
  %7 = icmp slt i32 %6, 600
  br i1 %7, label %"10", label %"55"

"10":                                             ; preds = %"7"
  store i32 0, i32* %1, align 4
  br label %"11"

"11":                                             ; preds = %"48", %"10"
  %8 = load i32, i32* %1, align 4
  %9 = icmp slt i32 %8, 400
  br i1 %9, label %"14", label %"51"

"14":                                             ; preds = %"11"
  %10 = load i32, i32* %0, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %11
  %13 = load i32, i32* %1, align 4
  %14 = sext i32 %13 to i64
  %15 = getelementptr [400 x i32], [400 x i32]* %12, i64 0, i64 %14
  %16 = load i32, i32* %15, align 4
  store i32 %16, i32* %2, align 4
  %17 = load i32, i32* %2, align 4
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %"24", label %"25"

"24":                                             ; preds = %"14"
  br label %"28"

"25":                                             ; preds = %"14"
  %19 = load i32, i32* %2, align 4
  %20 = sub nsw i32 %19, 1
  br label %"28"

"28":                                             ; preds = %"25", %"24"
  %21 = phi i32 [ 15, %"24" ], [ %20, %"25" ]
  store i32 %21, i32* %3, align 4
  %22 = load i32, i32* %0, align 4
  %23 = load i32, i32* %1, align 4
  %24 = load i32, i32* %3, align 4
  %25 = call i32 @neighbors_count(i32 %22, i32 %23, i32 %24)
  store i32 %25, i32* %4, align 4
  %26 = load i32, i32* %4, align 4
  %27 = icmp sge i32 %26, 1
  br i1 %27, label %"36", label %"38"

"36":                                             ; preds = %"28"
  %28 = load i32, i32* %3, align 4
  store i32 %28, i32* %5, align 4
  br label %"40"

"38":                                             ; preds = %"28"
  %29 = load i32, i32* %2, align 4
  store i32 %29, i32* %5, align 4
  br label %"40"

"40":                                             ; preds = %"38", %"36"
  %30 = load i32, i32* %5, align 4
  %31 = load i32, i32* %0, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @tmp_surf, i64 0, i64 %32
  %34 = load i32, i32* %1, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr [400 x i32], [400 x i32]* %33, i64 0, i64 %35
  store i32 %30, i32* %36, align 4
  br label %"48"

"48":                                             ; preds = %"40"
  %37 = load i32, i32* %1, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, i32* %1, align 4
  br label %"11"

"51":                                             ; preds = %"11"
  br label %"52"

"52":                                             ; preds = %"51"
  %39 = load i32, i32* %0, align 4
  %40 = add nsw i32 %39, 1
  store i32 %40, i32* %0, align 4
  br label %"7"

"55":                                             ; preds = %"7"
  ret void
}

define void @swap() {
"0":
  %0 = alloca i32, align 4
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  br label %"4"

"4":                                              ; preds = %"43", %"0"
  %3 = load i32, i32* %0, align 4
  %4 = icmp slt i32 %3, 600
  br i1 %4, label %"7", label %"46"

"7":                                              ; preds = %"4"
  store i32 0, i32* %1, align 4
  br label %"8"

"8":                                              ; preds = %"39", %"7"
  %5 = load i32, i32* %1, align 4
  %6 = icmp slt i32 %5, 400
  br i1 %6, label %"11", label %"42"

"11":                                             ; preds = %"8"
  %7 = load i32, i32* %0, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %8
  %10 = load i32, i32* %1, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr [400 x i32], [400 x i32]* %9, i64 0, i64 %11
  %13 = load i32, i32* %12, align 4
  store i32 %13, i32* %2, align 4
  %14 = load i32, i32* %0, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @tmp_surf, i64 0, i64 %15
  %17 = load i32, i32* %1, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr [400 x i32], [400 x i32]* %16, i64 0, i64 %18
  %20 = load i32, i32* %19, align 4
  %21 = load i32, i32* %0, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %22
  %24 = load i32, i32* %1, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr [400 x i32], [400 x i32]* %23, i64 0, i64 %25
  store i32 %20, i32* %26, align 4
  %27 = load i32, i32* %2, align 4
  %28 = load i32, i32* %0, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @tmp_surf, i64 0, i64 %29
  %31 = load i32, i32* %1, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr [400 x i32], [400 x i32]* %30, i64 0, i64 %32
  store i32 %27, i32* %33, align 4
  br label %"39"

"39":                                             ; preds = %"11"
  %34 = load i32, i32* %1, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %1, align 4
  br label %"8"

"42":                                             ; preds = %"8"
  br label %"43"

"43":                                             ; preds = %"42"
  %36 = load i32, i32* %0, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, i32* %0, align 4
  br label %"4"

"46":                                             ; preds = %"4"
  ret void
}

declare void @dr_flush()

declare i32 @dr_rand()

declare void @dr_init_window(i32, i32)

declare void @dr_put_pixel(i32, i32, i32)

define i32 @neighbors_count(i32 %0, i32 %1, i32 %2) {
"0":
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  store i32 %2, i32* %5, align 4
  store i32 0, i32* %6, align 4
  %9 = load i32, i32* %3, align 4
  %10 = sub nsw i32 %9, 1
  store i32 %10, i32* %7, align 4
  br label %"12"

"12":                                             ; preds = %"65", %"0"
  %11 = load i32, i32* %7, align 4
  %12 = load i32, i32* %3, align 4
  %13 = add nsw i32 %12, 1
  %14 = icmp sle i32 %11, %13
  br i1 %14, label %"17", label %"68"

"17":                                             ; preds = %"12"
  %15 = load i32, i32* %4, align 4
  %16 = sub nsw i32 %15, 1
  store i32 %16, i32* %8, align 4
  br label %"20"

"20":                                             ; preds = %"61", %"17"
  %17 = load i32, i32* %8, align 4
  %18 = load i32, i32* %4, align 4
  %19 = add nsw i32 %18, 1
  %20 = icmp sle i32 %17, %19
  br i1 %20, label %"25", label %"64"

"25":                                             ; preds = %"20"
  %21 = load i32, i32* %7, align 4
  %22 = load i32, i32* %3, align 4
  %23 = icmp eq i32 %21, %22
  br i1 %23, label %"29", label %"34"

"29":                                             ; preds = %"25"
  %24 = load i32, i32* %8, align 4
  %25 = load i32, i32* %4, align 4
  %26 = icmp eq i32 %24, %25
  br i1 %26, label %"33", label %"34"

"33":                                             ; preds = %"29"
  br label %"61"

"34":                                             ; preds = %"29", %"25"
  %27 = load i32, i32* %7, align 4
  %28 = icmp slt i32 %27, 0
  br i1 %28, label %"46", label %"37"

"37":                                             ; preds = %"34"
  %29 = load i32, i32* %7, align 4
  %30 = icmp sge i32 %29, 600
  br i1 %30, label %"46", label %"40"

"40":                                             ; preds = %"37"
  %31 = load i32, i32* %8, align 4
  %32 = icmp slt i32 %31, 0
  br i1 %32, label %"46", label %"43"

"43":                                             ; preds = %"40"
  %33 = load i32, i32* %8, align 4
  %34 = icmp sge i32 %33, 400
  br i1 %34, label %"46", label %"47"

"46":                                             ; preds = %"43", %"40", %"37", %"34"
  br label %"61"

"47":                                             ; preds = %"43"
  %35 = load i32, i32* %7, align 4
  %36 = sext i32 %35 to i64
  %37 = getelementptr [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %36
  %38 = load i32, i32* %8, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr [400 x i32], [400 x i32]* %37, i64 0, i64 %39
  %41 = load i32, i32* %40, align 4
  %42 = load i32, i32* %5, align 4
  %43 = icmp eq i32 %41, %42
  br i1 %43, label %"57", label %"60"

"57":                                             ; preds = %"47"
  %44 = load i32, i32* %6, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %6, align 4
  br label %"60"

"60":                                             ; preds = %"57", %"47"
  br label %"61"

"61":                                             ; preds = %"60", %"46", %"33"
  %46 = load i32, i32* %8, align 4
  %47 = add nsw i32 %46, 1
  store i32 %47, i32* %8, align 4
  br label %"20"

"64":                                             ; preds = %"20"
  br label %"65"

"65":                                             ; preds = %"64"
  %48 = load i32, i32* %7, align 4
  %49 = add nsw i32 %48, 1
  store i32 %49, i32* %7, align 4
  br label %"12"

"68":                                             ; preds = %"12"
  %50 = load i32, i32* %6, align 4
  ret i32 %50
}