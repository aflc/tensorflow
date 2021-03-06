// RUN: tf-opt -lhlo-legalize-to-affine %s -o - | FileCheck %s

// Smoke test.
// CHECK-LABEL: func @min_op
func @min_op(%arg0: memref<4x3x2x1xf32>, %arg1: memref<4x3x2x1xf32>, %out: memref<4x3x2x1xf32>) -> () {
  // CHECK-NEXT: affine.for %[[I:.*]] = 0 to 4 {
  // CHECK-NEXT: affine.for %[[J:.*]] = 0 to 3 {
  // CHECK-NEXT: affine.for %[[K:.*]] = 0 to 2 {
  // CHECK-NEXT: affine.for %[[L:.*]] = 0 to 1 {
  // CHECK-NEXT: %[[LHS:.*]] = load %{{.*}}[%[[I]], %[[J]], %[[K]], %[[L]]] : memref<4x3x2x1xf32>
  // CHECK-NEXT: %[[RHS:.*]] = load %{{.*}}[%[[I]], %[[J]], %[[K]], %[[L]]] : memref<4x3x2x1xf32>
  // CHECK-NEXT: %[[MIN_PREDICATE:.*]] = cmpf "olt", %[[LHS]], %[[RHS]] : f32
  // CHECK-NEXT: %[[MIN:.*]] = select %[[MIN_PREDICATE]], %[[LHS]], %[[RHS]] : f32
  // CHECK-NEXT: store %[[MIN]], %{{.*}}[%[[I]], %[[J]], %[[K]], %[[L]]] : memref<4x3x2x1xf32>
  // CHECK: return
  "xla_lhlo.min"(%arg0, %arg1, %out) {name = "min.1"} :
      (memref<4x3x2x1xf32>, memref<4x3x2x1xf32>, memref<4x3x2x1xf32>) -> ()
  return
}

// Add tests.
// CHECK-LABEL: func @float_add_op
func @float_add_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: addf %{{.*}}, %{{.*}} : f32
  "xla_lhlo.add"(%arg0, %arg1, %out) {name = "add.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_add_op
func @int_add_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: addi %{{.*}}, %{{.*}} : i32
  "xla_lhlo.add"(%arg0, %arg1, %out) {name = "add.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// And test.
// CHECK-LABEL: func @int_and_op
func @int_and_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: and %{{.*}}, %{{.*}} : i32
  "xla_lhlo.and"(%arg0, %arg1, %out) {name = "and.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// Div tests.
// CHECK-LABEL: func @float_div_op
func @float_div_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: divf %{{.*}}, %{{.*}} : f32
  "xla_lhlo.div"(%arg0, %arg1, %out) {name = "div.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_div_op
func @int_div_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: divis %{{.*}}, %{{.*}} : i32
  "xla_lhlo.div"(%arg0, %arg1, %out) {name = "div.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// Max tests.
// CHECK-LABEL: func @float_max_op
func @float_max_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: %[[CHECK:.*]] = cmpf "ogt", %[[ONE:.*]], %[[TWO:.*]] : f32
  // CHECK: select %[[CHECK]], %[[ONE]], %[[TWO]] : f32
  "xla_lhlo.max"(%arg0, %arg1, %out) {name = "max.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_max_op
func @int_max_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: %[[CHECK:.*]] = cmpi "sgt", %[[ONE:.*]], %[[TWO:.*]] : i32
  // CHECK: select %[[CHECK]], %[[ONE]], %[[TWO]] : i32
  "xla_lhlo.max"(%arg0, %arg1, %out) {name = "max.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// Min tests.
// CHECK-LABEL: func @float_min_op
func @float_min_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: %[[CHECK:.*]] = cmpf "olt", %[[ONE:.*]], %[[TWO:.*]] : f32
  // CHECK: select %[[CHECK]], %[[ONE]], %[[TWO]] : f32
  "xla_lhlo.min"(%arg0, %arg1, %out) {name = "min.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_min_op
func @int_min_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: %[[CHECK:.*]] = cmpi "slt", %[[ONE:.*]], %[[TWO:.*]] : i32
  // CHECK: select %[[CHECK]], %[[ONE]], %[[TWO]] : i32
  "xla_lhlo.min"(%arg0, %arg1, %out) {name = "min.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// Mul tests.
// CHECK-LABEL: func @float_mul_op
func @float_mul_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: mulf %{{.*}}, %{{.*}} : f32
  "xla_lhlo.mul"(%arg0, %arg1, %out) {name = "mul.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_mul_op
func @int_mul_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: muli %{{.*}}, %{{.*}} : i32
  "xla_lhlo.mul"(%arg0, %arg1, %out) {name = "mul.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}

// Sub tests.
// CHECK-LABEL: func @float_sub_op
func @float_sub_op(%arg0: memref<7xf32>, %arg1: memref<7xf32>, %out: memref<7xf32>) -> () {
  // CHECK: subf %{{.*}}, %{{.*}} : f32
  "xla_lhlo.sub"(%arg0, %arg1, %out) {name = "sub.1"} : (memref<7xf32>, memref<7xf32>, memref<7xf32>) -> ()
  return
}
// CHECK-LABEL: func @int_sub_op
func @int_sub_op(%arg0: memref<7xi32>, %arg1: memref<7xi32>, %out: memref<7xi32>) -> () {
  // CHECK: subi %{{.*}}, %{{.*}} : i32
  "xla_lhlo.sub"(%arg0, %arg1, %out) {name = "sub.1"} : (memref<7xi32>, memref<7xi32>, memref<7xi32>) -> ()
  return
}
