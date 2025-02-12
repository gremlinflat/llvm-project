// RUN: not llvm-mc -triple=amdgcn -mcpu=tahiti -show-encoding %s | FileCheck %s --check-prefix=SICI
// RUN: not llvm-mc -triple=amdgcn -mcpu=hawaii -show-encoding %s | FileCheck %s --check-prefix=CI --check-prefix=SICI
// RUN: not llvm-mc -triple=amdgcn -mcpu=tonga -show-encoding %s | FileCheck %s --check-prefix=VI

// Make sure interp instructions disassemble regardless of lds bank count
// RUN: not llvm-mc -triple=amdgcn -mcpu=gfx810 -show-encoding %s | FileCheck %s --check-prefix=VI

// RUN: not llvm-mc -triple=amdgcn -mcpu=tahiti %s 2>&1 | FileCheck %s --check-prefix=NOSI --check-prefix=NOSICI --implicit-check-not=error:
// RUN: not llvm-mc -triple=amdgcn -mcpu=hawaii %s 2>&1 | FileCheck %s -check-prefix=NOCI --check-prefix=NOSICI --implicit-check-not=error:
// RUN: not llvm-mc -triple=amdgcn -mcpu=tonga %s 2>&1 | FileCheck %s --check-prefix=NOVI --implicit-check-not=error:
// RUN: not llvm-mc -triple=amdgcn -mcpu=gfx810 %s 2>&1 | FileCheck -check-prefix=NOVI --implicit-check-not=error: %s

//===----------------------------------------------------------------------===//
// VOPC Instructions
//===----------------------------------------------------------------------===//

// Test forced e64 encoding

v_cmp_lt_f32_e64 s[2:3], v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x40]

// Test forcing e64 with vcc dst

v_cmp_lt_f32_e64 vcc, v4, v6
// SICI: v_cmp_lt_f32_e64 vcc, v4, v6 ; encoding: [0x6a,0x00,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI: v_cmp_lt_f32_e64 vcc, v4, v6 ; encoding: [0x6a,0x00,0x41,0xd0,0x04,0x0d,0x02,0x00]

//
// Modifier tests:
//

v_cmp_lt_f32 s[2:3] -v4, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -v4, v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x20]
// VI:   v_cmp_lt_f32_e64 s[2:3], -v4, v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x20]

v_cmp_lt_f32 s[2:3]  v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x40]

v_cmp_lt_f32 s[2:3] -v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x60]
// VI:   v_cmp_lt_f32_e64 s[2:3], -v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x60]

v_cmp_lt_f32 s[2:3] |v4|, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], |v4|, v6 ; encoding: [0x02,0x01,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], |v4|, v6 ; encoding: [0x02,0x01,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] v4, |v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, |v6| ; encoding: [0x02,0x02,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, |v6| ; encoding: [0x02,0x02,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] |v4|, |v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], |v4|, |v6| ; encoding: [0x02,0x03,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], |v4|, |v6| ; encoding: [0x02,0x03,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] -|v4|, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x02,0xd0,0x04,0x0d,0x02,0x20]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x41,0xd0,0x04,0x0d,0x02,0x20]

v_cmp_lt_f32 s[2:3] -abs(v4), v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x02,0xd0,0x04,0x0d,0x02,0x20]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x41,0xd0,0x04,0x0d,0x02,0x20]

v_cmp_lt_f32 s[2:3] v4, -|v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x41,0xd0,0x04,0x0d,0x02,0x40]

v_cmp_lt_f32 s[2:3] v4, -abs(v6)
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x41,0xd0,0x04,0x0d,0x02,0x40]

v_cmp_lt_f32 s[2:3] -|v4|, -|v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x02,0xd0,0x04,0x0d,0x02,0x60]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x41,0xd0,0x04,0x0d,0x02,0x60]

v_cmp_lt_f32 s[2:3] -abs(v4), -abs(v6)
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x02,0xd0,0x04,0x0d,0x02,0x60]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x41,0xd0,0x04,0x0d,0x02,0x60]

//
// Instruction tests:
//

v_cmp_f_f32 s[2:3], v4, v6
// SICI: v_cmp_f_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x00,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x40,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3], v4, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_eq_f32 s[2:3], v4, v6
// SICI: v_cmp_eq_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x04,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_eq_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x42,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_le_f32 s[2:3], v4, v6
// SICI: v_cmp_le_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x06,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_le_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x43,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_gt_f32 s[2:3], v4, v6
// SICI: v_cmp_gt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x08,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_gt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x44,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lg_f32 s[2:3], v4, v6
// SICI: v_cmp_lg_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x0a,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lg_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x45,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_ge_f32 s[2:3], v4, v6
// SICI: v_cmp_ge_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x0c,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_ge_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x46,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of v_cmp_*_f32
// TODO: Add tests for v_cmpx_*_f32

v_cmp_f_f64 s[2:3], v[4:5], v[6:7]
// SICI: v_cmp_f_f64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x40,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_f64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x60,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of v_cmp_*_f64
// TODO: Add tests for the rest of the floating-point comparision instructions.

v_cmp_f_i32 s[2:3], v4, v6
// SICI: v_cmp_f_i32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x00,0xd1,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_i32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0xc0,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add test for the rest of v_cmp_*_i32

v_cmp_f_i64 s[2:3], v[4:5], v[6:7]
// SICI: v_cmp_f_i64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x40,0xd1,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_i64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0xe0,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of the instructions.

//===----------------------------------------------------------------------===//
// VOP1 Instructions
//===----------------------------------------------------------------------===//

// Test forced e64 encoding with e32 operands

v_mov_b32_e64 v1, v2
// SICI: v_mov_b32_e64 v1, v2 ; encoding: [0x01,0x00,0x02,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_mov_b32_e64 v1, v2 ; encoding: [0x01,0x00,0x41,0xd1,0x02,0x01,0x00,0x00]

// Force e64 encoding for special instructions.
// FIXME, we should be printing the _e64 suffix for v_nop and v_clrexcp.

v_nop_e64
// SICI: v_nop ; encoding: [0x00,0x00,0x00,0xd3,0x00,0x00,0x00,0x00]
// VI:   v_nop ; encoding: [0x00,0x00,0x40,0xd1,0x00,0x00,0x00,0x00]

v_clrexcp_e64
// SICI: v_clrexcp ; encoding: [0x00,0x00,0x82,0xd3,0x00,0x00,0x00,0x00]
// VI:   v_clrexcp ; encoding: [0x00,0x00,0x75,0xd1,0x00,0x00,0x00,0x00]

//
// Modifier tests:
//

v_fract_f32 v1, -v2
// SICI: v_fract_f32_e64 v1, -v2 ; encoding: [0x01,0x00,0x40,0xd3,0x02,0x01,0x00,0x20]
// VI:   v_fract_f32_e64 v1, -v2 ; encoding: [0x01,0x00,0x5b,0xd1,0x02,0x01,0x00,0x20]

v_fract_f32 v1, |v2|
// SICI: v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x00]

v_fract_f32 v1, abs(v2)
// SICI: v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x00]

v_fract_f32 v1, -|v2|
// SICI: v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x20]
// VI:   v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x20]

v_fract_f32 v1, -abs(v2)
// SICI: v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x20]
// VI:   v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x20]

v_fract_f32 v1, v2 clamp
// SICI: v_fract_f32_e64 v1, v2 clamp ; encoding: [0x01,0x08,0x40,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_fract_f32_e64 v1, v2 clamp ; encoding: [0x01,0x80,0x5b,0xd1,0x02,0x01,0x00,0x00]

v_fract_f32 v1, v2 mul:2
// SICI: v_fract_f32_e64 v1, v2 mul:2 ; encoding: [0x01,0x00,0x40,0xd3,0x02,0x01,0x00,0x08]
// VI:   v_fract_f32_e64 v1, v2 mul:2 ; encoding: [0x01,0x00,0x5b,0xd1,0x02,0x01,0x00,0x08]

v_fract_f32 v1, v2, clamp div:2
// SICI: v_fract_f32_e64 v1, v2 clamp div:2 ; encoding: [0x01,0x08,0x40,0xd3,0x02,0x01,0x00,0x18]
// VI:   v_fract_f32_e64 v1, v2 clamp div:2 ; encoding: [0x01,0x80,0x5b,0xd1,0x02,0x01,0x00,0x18]

// TODO: Finish VOP1

///===---------------------------------------------------------------------===//
// VOP2 Instructions
///===---------------------------------------------------------------------===//

// Test forced e64 encoding with e32 operands

v_add_f32_e64 v1, v3, v5
// SICI: v_add_f32_e64 v1, v3, v5 ; encoding: [0x01,0x00,0x06,0xd2,0x03,0x0b,0x02,0x00]
// VI:   v_add_f32_e64 v1, v3, v5 ; encoding: [0x01,0x00,0x01,0xd1,0x03,0x0b,0x02,0x00]


// TODO: Modifier tests (v_cndmask done)

v_cndmask_b32 v1, v3, v5, s[4:5]
// SICI: v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd2,0x03,0x0b,0x12,0x00]
// VI:   v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd1,0x03,0x0b,0x12,0x00]

v_cndmask_b32_e64 v1, v3, v5, s[4:5]
// SICI: v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd2,0x03,0x0b,0x12,0x00]
// VI:   v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd1,0x03,0x0b,0x12,0x00]

v_cndmask_b32_e64 v1, v3, v5, vcc
// SICI: v_cndmask_b32_e64 v1, v3, v5, vcc ; encoding: [0x01,0x00,0x00,0xd2,0x03,0x0b,0xaa,0x01]
// VI:   v_cndmask_b32_e64 v1, v3, v5, vcc ; encoding: [0x01,0x00,0x00,0xd1,0x03,0x0b,0xaa,0x01]

v_cndmask_b32 v1, -v3, v5, s[4:5]
// SICI: v_cndmask_b32_e64 v1, -v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd2,0x03,0x0b,0x12,0x20]
// VI:   v_cndmask_b32_e64 v1, -v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd1,0x03,0x0b,0x12,0x20]

v_cndmask_b32_e64 v1, v3, |v5|, s[4:5]
// SICI: v_cndmask_b32_e64 v1, v3, |v5|, s[4:5] ; encoding: [0x01,0x02,0x00,0xd2,0x03,0x0b,0x12,0x00]
// VI:   v_cndmask_b32_e64 v1, v3, |v5|, s[4:5] ; encoding: [0x01,0x02,0x00,0xd1,0x03,0x0b,0x12,0x00]

v_cndmask_b32_e64 v1, -abs(v3), v5, vcc
// SICI: v_cndmask_b32_e64 v1, -|v3|, v5, vcc ; encoding: [0x01,0x01,0x00,0xd2,0x03,0x0b,0xaa,0x21]
// VI:   v_cndmask_b32_e64 v1, -|v3|, v5, vcc ; encoding: [0x01,0x01,0x00,0xd1,0x03,0x0b,0xaa,0x21]

//TODO: readlane, writelane

v_add_f32 v1, v3, s5
// SICI: v_add_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x06,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_add_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x01,0xd1,0x03,0x0b,0x00,0x00]

v_sub_f32 v1, v3, s5
// SICI: v_sub_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x08,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_sub_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x02,0xd1,0x03,0x0b,0x00,0x00]

v_subrev_f32 v1, v3, s5
// SICI: v_subrev_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0a,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_subrev_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x03,0xd1,0x03,0x0b,0x00,0x00]

v_mac_legacy_f32 v1, v3, s5
// SICI: v_mac_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0c,0xd2,0x03,0x0b,0x00,0x00]
// NOVI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mul_legacy_f32 v1, v3, s5
// SICI: v_mul_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0e,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x04,0xd1,0x03,0x0b,0x00,0x00]

v_mul_f32 v1, v3, s5
// SICI: v_mul_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x10,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x05,0xd1,0x03,0x0b,0x00,0x00]

v_mul_i32_i24 v1, v3, s5
// SICI: v_mul_i32_i24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x12,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_i32_i24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x06,0xd1,0x03,0x0b,0x00,0x00]

v_mul_i32_i24 v1, v3, s5 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI:   v_mul_i32_i24_e64 v1, v3, s5 clamp ; encoding: [0x01,0x80,0x06,0xd1,0x03,0x0b,0x00,0x00]

v_mul_u32_u24 v1, v3, s5
// SICI: v_mul_u32_u24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x16,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_u32_u24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x08,0xd1,0x03,0x0b,0x00,0x00]

v_mul_u32_u24 v1, v3, s5 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI:   v_mul_u32_u24_e64 v1, v3, s5 clamp ; encoding: [0x01,0x80,0x08,0xd1,0x03,0x0b,0x00,0x00]

v_mac_f32_e64 v0, v1, v2
// SICI: v_mac_f32_e64 v0, v1, v2 ; encoding: [0x00,0x00,0x3e,0xd2,0x01,0x05,0x02,0x00]
// VI:   v_mac_f32_e64 v0, v1, v2 ; encoding: [0x00,0x00,0x16,0xd1,0x01,0x05,0x02,0x00]

v_mac_f32_e64 v0, v1, v2 clamp
// SICI: v_mac_f32_e64 v0, v1, v2 clamp ; encoding: [0x00,0x08,0x3e,0xd2,0x01,0x05,0x02,0x00]
// VI:   v_mac_f32_e64 v0, v1, v2 clamp ; encoding: [0x00,0x80,0x16,0xd1,0x01,0x05,0x02,0x00]

v_mac_f32_e64 v0, v1, v2 mul:2
// SICI: v_mac_f32_e64 v0, v1, v2 mul:2 ; encoding: [0x00,0x00,0x3e,0xd2,0x01,0x05,0x02,0x08]
// VI:   v_mac_f32_e64 v0, v1, v2 mul:2 ; encoding: [0x00,0x00,0x16,0xd1,0x01,0x05,0x02,0x08]

v_mac_f32_e64 v0, -v1, |v2|
// SICI: v_mac_f32_e64 v0, -v1, |v2| ; encoding: [0x00,0x02,0x3e,0xd2,0x01,0x05,0x02,0x20]
// VI:   v_mac_f32_e64 v0, -v1, |v2| ; encoding: [0x00,0x02,0x16,0xd1,0x01,0x05,0x02,0x20]

v_mac_f16_e64 v0, 0.5, flat_scratch_lo
// VI: v_mac_f16_e64 v0, 0.5, flat_scratch_lo ; encoding: [0x00,0x00,0x23,0xd1,0xf0,0xcc,0x00,0x00]
// NOCI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mac_f16_e64 v0, -4.0, flat_scratch_lo
// VI: v_mac_f16_e64 v0, -4.0, flat_scratch_lo ; encoding: [0x00,0x00,0x23,0xd1,0xf7,0xcc,0x00,0x00]
// NOCI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mac_f16_e64 v0, flat_scratch_lo, -4.0
// VI: v_mac_f16_e64 v0, flat_scratch_lo, -4.0 ; encoding: [0x00,0x00,0x23,0xd1,0x66,0xee,0x01,0x00]
// NOCI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_add_u32 v84, vcc, v13, s31 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_add_u32_e64 v84, vcc, v13, s31 clamp ; encoding: [0x54,0xea,0x19,0xd1,0x0d,0x3f,0x00,0x00]

v_sub_u32 v84, s[2:3], v13, s31 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_sub_u32_e64 v84, s[2:3], v13, s31 clamp ; encoding: [0x54,0x82,0x1a,0xd1,0x0d,0x3f,0x00,0x00]

v_subrev_u32 v84, vcc, v13, s31 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_subrev_u32_e64 v84, vcc, v13, s31 clamp ; encoding: [0x54,0xea,0x1b,0xd1,0x0d,0x3f,0x00,0x00]

v_addc_u32 v84, s[4:5], v13, v31, vcc clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_addc_u32_e64 v84, s[4:5], v13, v31, vcc clamp ; encoding: [0x54,0x84,0x1c,0xd1,0x0d,0x3f,0xaa,0x01]

v_subb_u32 v84, s[2:3], v13, v31, vcc clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_subb_u32_e64 v84, s[2:3], v13, v31, vcc clamp ; encoding: [0x54,0x82,0x1d,0xd1,0x0d,0x3f,0xaa,0x01]

v_subbrev_u32 v84, vcc, v13, v31, s[6:7] clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_subbrev_u32_e64 v84, vcc, v13, v31, s[6:7] clamp ; encoding: [0x54,0xea,0x1e,0xd1,0x0d,0x3f,0x1a,0x00]

///===---------------------------------------------------------------------===//
// VOP3 Instructions
///===---------------------------------------------------------------------===//

// TODO: Modifier tests

v_mad_legacy_f32 v2, v4, v6, v8
// SICI: v_mad_legacy_f32 v2, v4, v6, v8 ; encoding: [0x02,0x00,0x80,0xd2,0x04,0x0d,0x22,0x04]
// VI:   v_mad_legacy_f32 v2, v4, v6, v8 ; encoding: [0x02,0x00,0xc0,0xd1,0x04,0x0d,0x22,0x04]

v_add_f64 v[0:1], v[2:3], v[5:6]
// SICI: v_add_f64 v[0:1], v[2:3], v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64_e64 v[0:1], v[2:3], v[5:6]
// SICI: v_add_f64 v[0:1], v[2:3], v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64 v[0:1], -v[2:3], v[5:6]
// SICI: v_add_f64 v[0:1], -v[2:3], v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x20]
// VI:   v_add_f64 v[0:1], -v[2:3], v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x20]

v_add_f64_e64 v[0:1], -v[2:3], v[5:6]
// SICI: v_add_f64 v[0:1], -v[2:3], v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x20]
// VI:   v_add_f64 v[0:1], -v[2:3], v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x20]

v_add_f64 v[0:1], v[2:3], -v[5:6]
// SICI: v_add_f64 v[0:1], v[2:3], -v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x40]
// VI:   v_add_f64 v[0:1], v[2:3], -v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x40]

v_add_f64_e64 v[0:1], v[2:3], -v[5:6]
// SICI: v_add_f64 v[0:1], v[2:3], -v[5:6] ; encoding: [0x00,0x00,0xc8,0xd2,0x02,0x0b,0x02,0x40]
// VI:   v_add_f64 v[0:1], v[2:3], -v[5:6] ; encoding: [0x00,0x00,0x80,0xd2,0x02,0x0b,0x02,0x40]

v_add_f64 v[0:1], |v[2:3]|, v[5:6]
// SICI: v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64 v[0:1], abs(v[2:3]), v[5:6]
// SICI: v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64_e64 v[0:1], |v[2:3]|, v[5:6]
// SICI: v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64_e64 v[0:1], abs(v[2:3]), v[5:6]
// SICI: v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], |v[2:3]|, v[5:6] ; encoding: [0x00,0x01,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64 v[0:1], v[2:3], |v[5:6]|
// SICI: v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64 v[0:1], v[2:3], abs(v[5:6])
// SICI: v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64_e64 v[0:1], v[2:3], |v[5:6]|
// SICI: v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64_e64 v[0:1], v[2:3], abs(v[5:6])
// SICI: v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0xc8,0xd2,0x02,0x0b,0x02,0x00]
// VI:   v_add_f64 v[0:1], v[2:3], |v[5:6]| ; encoding: [0x00,0x02,0x80,0xd2,0x02,0x0b,0x02,0x00]

v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4
// SICI: v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x0a,0xc8,0xd2,0x02,0x0b,0x02,0x30]
// VI:   v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x82,0x80,0xd2,0x02,0x0b,0x02,0x30]

v_add_f64 v[0:1], -v[2:3], abs(v[5:6]) clamp mul:4
// SICI: v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x0a,0xc8,0xd2,0x02,0x0b,0x02,0x30]
// VI:   v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x82,0x80,0xd2,0x02,0x0b,0x02,0x30]

v_add_f64_e64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4
// SICI: v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x0a,0xc8,0xd2,0x02,0x0b,0x02,0x30]
// VI:   v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x82,0x80,0xd2,0x02,0x0b,0x02,0x30]

v_add_f64_e64 v[0:1], -v[2:3], abs(v[5:6]) clamp mul:4
// SICI: v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x0a,0xc8,0xd2,0x02,0x0b,0x02,0x30]
// VI:   v_add_f64 v[0:1], -v[2:3], |v[5:6]| clamp mul:4 ; encoding: [0x00,0x82,0x80,0xd2,0x02,0x0b,0x02,0x30]

v_div_scale_f64  v[24:25], vcc, v[22:23], v[22:23], v[20:21]
// SICI: v_div_scale_f64 v[24:25], vcc, v[22:23], v[22:23], v[20:21] ; encoding: [0x18,0x6a,0xdc,0xd2,0x16,0x2d,0x52,0x04]
// VI:   v_div_scale_f64 v[24:25], vcc, v[22:23], v[22:23], v[20:21] ; encoding: [0x18,0x6a,0xe1,0xd1,0x16,0x2d,0x52,0x04]

v_div_scale_f64  v[24:25], s[10:11], -v[22:23], v[20:21], v[20:21] clamp
// SICI: v_div_scale_f64 v[24:25], s[10:11], -v[22:23], v[20:21], v[20:21] clamp ; encoding: [0x18,0x0a,0xdc,0xd2,0x16,0x29,0x52,0x24]
// VI:   v_div_scale_f64 v[24:25], s[10:11], -v[22:23], v[20:21], v[20:21] clamp ; encoding: [0x18,0x8a,0xe1,0xd1,0x16,0x29,0x52,0x24]

v_div_scale_f64  v[24:25], s[10:11], v[22:23], -v[20:21], v[20:21] clamp mul:2
// SICI: v_div_scale_f64 v[24:25], s[10:11], v[22:23], -v[20:21], v[20:21] clamp mul:2 ; encoding: [0x18,0x0a,0xdc,0xd2,0x16,0x29,0x52,0x4c]
// VI:   v_div_scale_f64 v[24:25], s[10:11], v[22:23], -v[20:21], v[20:21] clamp mul:2 ; encoding: [0x18,0x8a,0xe1,0xd1,0x16,0x29,0x52,0x4c]

v_div_scale_f64  v[24:25], s[10:11], v[22:23], v[20:21], -v[20:21]
// SICI: v_div_scale_f64 v[24:25], s[10:11], v[22:23], v[20:21], -v[20:21] ; encoding: [0x18,0x0a,0xdc,0xd2,0x16,0x29,0x52,0x84]
// VI:   v_div_scale_f64 v[24:25], s[10:11], v[22:23], v[20:21], -v[20:21] ; encoding: [0x18,0x0a,0xe1,0xd1,0x16,0x29,0x52,0x84]

v_div_scale_f32  v24, vcc, v22, v22, v20
// SICI: v_div_scale_f32 v24, vcc, v22, v22, v20 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0x52,0x04]
// VI:   v_div_scale_f32 v24, vcc, v22, v22, v20 ; encoding: [0x18,0x6a,0xe0,0xd1,0x16,0x2d,0x52,0x04]

v_div_scale_f32  v24, vcc, -v22, v22, v20
// SICI: v_div_scale_f32 v24, vcc, -v22, v22, v20 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0x52,0x24]
// VI:   v_div_scale_f32 v24, vcc, -v22, v22, v20 ; encoding: [0x18,0x6a,0xe0,0xd1,0x16,0x2d,0x52,0x24]

v_div_scale_f32  v24, vcc, v22, -v22, v20 clamp
// SICI: v_div_scale_f32 v24, vcc, v22, -v22, v20 clamp ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0x52,0x44]
// VI:   v_div_scale_f32 v24, vcc, v22, -v22, v20 clamp ; encoding: [0x18,0xea,0xe0,0xd1,0x16,0x2d,0x52,0x44]

v_div_scale_f32  v24, vcc, v22, v22, -v20 clamp div:2
// SICI: v_div_scale_f32 v24, vcc, v22, v22, -v20 clamp div:2 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0x52,0x9c]
// VI:   v_div_scale_f32 v24, vcc, v22, v22, -v20 clamp div:2 ; encoding: [0x18,0xea,0xe0,0xd1,0x16,0x2d,0x52,0x9c]

v_div_scale_f32  v24, s[10:11], v22, v22, v20
// SICI: v_div_scale_f32 v24, s[10:11], v22, v22, v20 ; encoding: [0x18,0x0a,0xda,0xd2,0x16,0x2d,0x52,0x04]
// VI:   v_div_scale_f32 v24, s[10:11], v22, v22, v20 ; encoding: [0x18,0x0a,0xe0,0xd1,0x16,0x2d,0x52,0x04]

v_div_scale_f32  v24, vcc, v22, 1.0, v22
// SICI: v_div_scale_f32 v24, vcc, v22, 1.0, v22 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0xe5,0x59,0x04]
// VI:   v_div_scale_f32 v24, vcc, v22, 1.0, v22 ; encoding: [0x18,0x6a,0xe0,0xd1,0x16,0xe5,0x59,0x04]

v_div_scale_f32  v24, vcc, v22, v22, -2.0
// SICI: v_div_scale_f32 v24, vcc, v22, v22, -2.0 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0xd6,0x03]
// VI:   v_div_scale_f32 v24, vcc, v22, v22, -2.0 ; encoding: [0x18,0x6a,0xe0,0xd1,0x16,0x2d,0xd6,0x03]

v_div_scale_f32 v24, vcc, v22, v22, 0xc0000000
// SICI: v_div_scale_f32 v24, vcc, v22, v22, -2.0 ; encoding: [0x18,0x6a,0xda,0xd2,0x16,0x2d,0xd6,0x03]
// VI:   v_div_scale_f32 v24, vcc, v22, v22, -2.0 ; encoding: [0x18,0x6a,0xe0,0xd1,0x16,0x2d,0xd6,0x03]

v_mad_f32 v9, 0.5, v5, -v8
// SICI: v_mad_f32 v9, 0.5, v5, -v8      ; encoding: [0x09,0x00,0x82,0xd2,0xf0,0x0a,0x22,0x84]
// VI:   v_mad_f32 v9, 0.5, v5, -v8      ; encoding: [0x09,0x00,0xc1,0xd1,0xf0,0x0a,0x22,0x84]

v_mqsad_u32_u8 v[5:8], s[2:3], v4, v[0:3]
// CI: v_mqsad_u32_u8 v[5:8], s[2:3], v4, v[0:3] ; encoding: [0x05,0x00,0xea,0xd2,0x02,0x08,0x02,0x04]
// VI: v_mqsad_u32_u8 v[5:8], s[2:3], v4, v[0:3] ; encoding: [0x05,0x00,0xe7,0xd1,0x02,0x08,0x02,0x04]
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_u64_u32 v[5:6], s[12:13], s1, 0, 0
// CI: v_mad_u64_u32 v[5:6], s[12:13], s1, 0, 0 ; encoding: [0x05,0x0c,0xec,0xd2,0x01,0x00,0x01,0x02]
// VI: v_mad_u64_u32 v[5:6], s[12:13], s1, 0, 0 ; encoding: [0x05,0x0c,0xe8,0xd1,0x01,0x00,0x01,0x02]
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_i64_i32 v[5:6], s[12:13], s1, 0, v[254:255]
// CI: v_mad_i64_i32 v[5:6], s[12:13], s1, 0, v[254:255] ; encoding: [0x05,0x0c,0xee,0xd2,0x01,0x00,0xf9,0x07]
// VI: v_mad_i64_i32 v[5:6], s[12:13], s1, 0, v[254:255] ; encoding: [0x05,0x0c,0xe9,0xd1,0x01,0x00,0xf9,0x07]
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_cmp_class_f16_e64 s[10:11], v1, s2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_cmp_class_f16_e64 s[10:11], v1, s2 ; encoding: [0x0a,0x00,0x14,0xd0,0x01,0x05,0x00,0x00]

v_cmp_class_f32_e64 s[10:11], -v1, s2
// SICI: v_cmp_class_f32_e64 s[10:11], -v1, s2 ; encoding: [0x0a,0x00,0x10,0xd1,0x01,0x05,0x00,0x20]
// VI:   v_cmp_class_f32_e64 s[10:11], -v1, s2 ; encoding: [0x0a,0x00,0x10,0xd0,0x01,0x05,0x00,0x20]

v_cmp_class_f64_e64 s[10:11], -v[254:255], s2
// SICI: v_cmp_class_f64_e64 s[10:11], -v[254:255], s2 ; encoding: [0x0a,0x00,0x50,0xd1,0xfe,0x05,0x00,0x20]
// VI:   v_cmp_class_f64_e64 s[10:11], -v[254:255], s2 ; encoding: [0x0a,0x00,0x12,0xd0,0xfe,0x05,0x00,0x20]

v_cmpx_class_f16_e64 s[10:11], v255, s2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_cmpx_class_f16_e64 s[10:11], v255, s2 ; encoding: [0x0a,0x00,0x15,0xd0,0xff,0x05,0x00,0x00]

v_cmpx_class_f32_e64 s[10:11], 0, s101
// SICI: v_cmpx_class_f32_e64 s[10:11], 0, s101 ; encoding: [0x0a,0x00,0x30,0xd1,0x80,0xca,0x00,0x00]
// VI:   v_cmpx_class_f32_e64 s[10:11], 0, s101 ; encoding: [0x0a,0x00,0x11,0xd0,0x80,0xca,0x00,0x00]

v_cmpx_class_f64_e64 s[10:11], -v[1:2], s2
// SICI: v_cmpx_class_f64_e64 s[10:11], -v[1:2], s2 ; encoding: [0x0a,0x00,0x70,0xd1,0x01,0x05,0x00,0x20]
// VI:   v_cmpx_class_f64_e64 s[10:11], -v[1:2], s2 ; encoding: [0x0a,0x00,0x13,0xd0,0x01,0x05,0x00,0x20]

//
// Modifier tests:
//

v_mul_f64 v[0:1], |0|, |0|
// SICI: v_mul_f64 v[0:1], |0|, |0|      ; encoding: [0x00,0x03,0xca,0xd2,0x80,0x00,0x01,0x00]
// VI:   v_mul_f64 v[0:1], |0|, |0|      ; encoding: [0x00,0x03,0x81,0xd2,0x80,0x00,0x01,0x00]

v_cubeid_f32 v0, |-1|, |-1.0|, |1.0|
// SICI: v_cubeid_f32 v0, |-1|, |-1.0|, |1.0| ; encoding: [0x00,0x07,0x88,0xd2,0xc1,0xe6,0xc9,0x03]
// VI:   v_cubeid_f32 v0, |-1|, |-1.0|, |1.0| ; encoding: [0x00,0x07,0xc4,0xd1,0xc1,0xe6,0xc9,0x03]

///===---------------------------------------------------------------------===//
// VOP3 Legacy
///===---------------------------------------------------------------------===//

v_fma_f16_e64 v5, v1, v2, v3
// VI: v_fma_f16 v5, v1, v2, v3 ; encoding: [0x05,0x00,0xee,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_fma_f16 v5, v1, v2, 0.5
// VI: v_fma_f16 v5, v1, v2, 0.5 ; encoding: [0x05,0x00,0xee,0xd1,0x01,0x05,0xc2,0x03]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_fma_f16 v5, -v1, -v2, -v3
// VI: v_fma_f16 v5, -v1, -v2, -v3 ; encoding: [0x05,0x00,0xee,0xd1,0x01,0x05,0x0e,0xe4]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_fma_f16 v5, |v1|, |v2|, |v3|
// VI: v_fma_f16 v5, |v1|, |v2|, |v3| ; encoding: [0x05,0x07,0xee,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_fma_f16 v5, v1, v2, v3 clamp
// VI: v_fma_f16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xee,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16_e64 v5, v1, v2, v3
// VI: v_div_fixup_f16 v5, v1, v2, v3 ; encoding: [0x05,0x00,0xef,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, 0.5, v2, v3
// VI: v_div_fixup_f16 v5, 0.5, v2, v3 ; encoding: [0x05,0x00,0xef,0xd1,0xf0,0x04,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, v1, 0.5, v3
// VI: v_div_fixup_f16 v5, v1, 0.5, v3 ; encoding: [0x05,0x00,0xef,0xd1,0x01,0xe1,0x0d,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, v1, v2, 0.5
// VI: v_div_fixup_f16 v5, v1, v2, 0.5 ; encoding: [0x05,0x00,0xef,0xd1,0x01,0x05,0xc2,0x03]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, v1, v2, -4.0
// VI: v_div_fixup_f16 v5, v1, v2, -4.0 ; encoding: [0x05,0x00,0xef,0xd1,0x01,0x05,0xde,0x03]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, -v1, v2, v3
// VI: v_div_fixup_f16 v5, -v1, v2, v3 ; encoding: [0x05,0x00,0xef,0xd1,0x01,0x05,0x0e,0x24]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, v1, |v2|, v3
// VI: v_div_fixup_f16 v5, v1, |v2|, v3 ; encoding: [0x05,0x02,0xef,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_div_fixup_f16 v5, v1, v2, v3 clamp
// VI: v_div_fixup_f16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xef,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16_e64 v5, v1, v2, v3
// VI: v_mad_f16 v5, v1, v2, v3 ; encoding: [0x05,0x00,0xea,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, 0.5, v2, v3
// VI: v_mad_f16 v5, 0.5, v2, v3 ; encoding: [0x05,0x00,0xea,0xd1,0xf0,0x04,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, v1, 0.5, v3
// VI: v_mad_f16 v5, v1, 0.5, v3 ; encoding: [0x05,0x00,0xea,0xd1,0x01,0xe1,0x0d,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, v1, v2, 0.5
// VI: v_mad_f16 v5, v1, v2, 0.5 ; encoding: [0x05,0x00,0xea,0xd1,0x01,0x05,0xc2,0x03]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, v1, -v2, v3
// VI: v_mad_f16 v5, v1, -v2, v3 ; encoding: [0x05,0x00,0xea,0xd1,0x01,0x05,0x0e,0x44]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, v1, v2, |v3|
// VI: v_mad_f16 v5, v1, v2, |v3| ; encoding: [0x05,0x04,0xea,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_f16 v5, v1, v2, v3 clamp
// VI: v_mad_f16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xea,0xd1,0x01,0x05,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_i16_e64 v5, -1, v2, v3
// VI: v_mad_i16 v5, -1, v2, v3 ; encoding: [0x05,0x00,0xec,0xd1,0xc1,0x04,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_i16 v5, v1, -4.0, v3
// VI: v_mad_i16 v5, v1, -4.0, v3 ; encoding: [0x05,0x00,0xec,0xd1,0x01,0xef,0x0d,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_i16 v5, v1, v2, 0
// VI: v_mad_i16 v5, v1, v2, 0 ; encoding: [0x05,0x00,0xec,0xd1,0x01,0x05,0x02,0x02]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_u16_e64 v5, -1, v2, v3
// VI: v_mad_u16 v5, -1, v2, v3 ; encoding: [0x05,0x00,0xeb,0xd1,0xc1,0x04,0x0e,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_u16 v5, v1, 0, v3
// VI: v_mad_u16 v5, v1, 0, v3 ; encoding: [0x05,0x00,0xeb,0xd1,0x01,0x01,0x0d,0x04]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_u16 v5, v1, v2, -4.0
// VI: v_mad_u16 v5, v1, v2, -4.0 ; encoding: [0x05,0x00,0xeb,0xd1,0x01,0x05,0xde,0x03]
// NOSICI: :[[@LINE-2]]:{{[0-9]+}}: error: instruction not supported on this GPU

///===---------------------------------------------------------------------===//
// VOP3 with Integer Clamp
///===---------------------------------------------------------------------===//

v_mad_i32_i24 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_mad_i32_i24 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xc2,0xd1,0x01,0x05,0x0e,0x04]

v_mad_u32_u24 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_mad_u32_u24 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xc3,0xd1,0x01,0x05,0x0e,0x04]

v_sad_u8 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_sad_u8 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xd9,0xd1,0x01,0x05,0x0e,0x04]

v_sad_hi_u8 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_sad_hi_u8 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xda,0xd1,0x01,0x05,0x0e,0x04]

v_sad_u16 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_sad_u16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xdb,0xd1,0x01,0x05,0x0e,0x04]

v_sad_u32 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_sad_u32 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xdc,0xd1,0x01,0x05,0x0e,0x04]

v_msad_u8 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_msad_u8 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xe4,0xd1,0x01,0x05,0x0e,0x04]

v_mqsad_pk_u16_u8 v[5:6], v[1:2], v2, v[3:4] clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// VI: v_mqsad_pk_u16_u8 v[5:6], v[1:2], v2, v[3:4] clamp ; encoding: [0x05,0x80,0xe6,0xd1,0x01,0x05,0x0e,0x04]

v_qsad_pk_u16_u8 v[5:6], v[1:2], v2, v[3:4] clamp
// VI: v_qsad_pk_u16_u8 v[5:6], v[1:2], v2, v[3:4] clamp ; encoding: [0x05,0x80,0xe5,0xd1,0x01,0x05,0x0e,0x04]
// NOCI: :[[@LINE-2]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mqsad_u32_u8 v[252:255], v[1:2], v2, v[3:6] clamp
// VI: v_mqsad_u32_u8 v[252:255], v[1:2], v2, v[3:6] clamp ; encoding: [0xfc,0x80,0xe7,0xd1,0x01,0x05,0x0e,0x04]
// NOCI: :[[@LINE-2]]:{{[0-9]+}}: error: integer clamping is not supported on this GPU
// NOSI: :[[@LINE-3]]:{{[0-9]+}}: error: instruction not supported on this GPU

v_mad_u16 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_mad_u16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xeb,0xd1,0x01,0x05,0x0e,0x04]

v_mad_i16 v5, v1, v2, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_mad_i16 v5, v1, v2, v3 clamp ; encoding: [0x05,0x80,0xec,0xd1,0x01,0x05,0x0e,0x04]

//
// v_interp*
//

v_interp_mov_f32_e64 v5, p10, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x00,0x00,0x00]

v_interp_mov_f32_e64 v5, p10, attr32.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr32.x ; encoding: [0x05,0x00,0x72,0xd2,0x20,0x00,0x00,0x00]

v_interp_mov_f32_e64 v5, p20, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p20, attr0.x ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x02,0x00,0x00]

v_interp_mov_f32_e64 v5, p10, attr0.w
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.w ; encoding: [0x05,0x00,0x72,0xd2,0xc0,0x00,0x00,0x00]

v_interp_mov_f32_e64 v5, p10, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x clamp ; encoding: [0x05,0x80,0x72,0xd2,0x00,0x00,0x00,0x00]

v_interp_mov_f32 v5, p10, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x clamp ; encoding: [0x05,0x80,0x72,0xd2,0x00,0x00,0x00,0x00]

v_interp_mov_f32_e64 v5, p10, attr0.x mul:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x mul:2 ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x00,0x00,0x08]

v_interp_mov_f32_e64 v5, p10, attr0.x mul:4
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x mul:4 ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x00,0x00,0x10]

v_interp_mov_f32_e64 v5, p10, attr0.x div:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x div:2 ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x00,0x00,0x18]

v_interp_mov_f32 v5, p10, attr0.x div:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: not a valid operand
// VI: v_interp_mov_f32_e64 v5, p10, attr0.x div:2 ; encoding: [0x05,0x00,0x72,0xd2,0x00,0x00,0x00,0x18]


v_interp_p1_f32_e64 v5, v2, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, v2, attr0.x ; encoding: [0x05,0x00,0x70,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1_f32_e64 v5, v2, attr0.y
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, v2, attr0.y ; encoding: [0x05,0x00,0x70,0xd2,0x40,0x04,0x02,0x00]

v_interp_p1_f32_e64 v5, -v2, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, -v2, attr0.x ; encoding: [0x05,0x00,0x70,0xd2,0x00,0x04,0x02,0x40]

v_interp_p1_f32_e64 v5, |v2|, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, |v2|, attr0.x ; encoding: [0x05,0x02,0x70,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1_f32_e64 v5, v2, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, v2, attr0.x clamp ; encoding: [0x05,0x80,0x70,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1_f32 v5, v2, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction
// VI: v_interp_p1_f32_e64 v5, v2, attr0.x clamp ; encoding: [0x05,0x80,0x70,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1_f32_e64 v5, v2, attr0.x mul:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p1_f32_e64 v5, v2, attr0.x mul:2 ; encoding: [0x05,0x00,0x70,0xd2,0x00,0x04,0x02,0x08]


v_interp_p2_f32_e64 v255, v2, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v255, v2, attr0.x ; encoding: [0xff,0x00,0x71,0xd2,0x00,0x04,0x02,0x00]

v_interp_p2_f32_e64 v5, v2, attr31.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v5, v2, attr31.x ; encoding: [0x05,0x00,0x71,0xd2,0x1f,0x04,0x02,0x00]

v_interp_p2_f32_e64 v5, -v2, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v5, -v2, attr0.x ; encoding: [0x05,0x00,0x71,0xd2,0x00,0x04,0x02,0x40]

v_interp_p2_f32_e64 v5, |v2|, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v5, |v2|, attr0.x ; encoding: [0x05,0x02,0x71,0xd2,0x00,0x04,0x02,0x00]

v_interp_p2_f32_e64 v5, v2, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v5, v2, attr0.x clamp ; encoding: [0x05,0x80,0x71,0xd2,0x00,0x04,0x02,0x00]

v_interp_p2_f32_e64 v5, v2, attr0.x div:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: e64 variant of this instruction is not supported
// VI: v_interp_p2_f32_e64 v5, v2, attr0.x div:2 ; encoding: [0x05,0x00,0x71,0xd2,0x00,0x04,0x02,0x18]


v_interp_p1ll_f16 v5, v2, attr31.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, v2, attr31.x ; encoding: [0x05,0x00,0x74,0xd2,0x1f,0x04,0x02,0x00]

v_interp_p1ll_f16 v5, v2, attr0.w
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, v2, attr0.w ; encoding: [0x05,0x00,0x74,0xd2,0xc0,0x04,0x02,0x00]

v_interp_p1ll_f16 v5, -v2, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, -v2, attr0.x ; encoding: [0x05,0x00,0x74,0xd2,0x00,0x04,0x02,0x40]

v_interp_p1ll_f16 v5, |v2|, attr0.x
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, |v2|, attr0.x ; encoding: [0x05,0x02,0x74,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1ll_f16 v5, v2, attr0.x high
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, v2, attr0.x high ; encoding: [0x05,0x00,0x74,0xd2,0x00,0x05,0x02,0x00]

v_interp_p1ll_f16 v5, v2, attr0.x clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, v2, attr0.x clamp ; encoding: [0x05,0x80,0x74,0xd2,0x00,0x04,0x02,0x00]

v_interp_p1ll_f16 v5, v2, attr0.x mul:4
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1ll_f16 v5, v2, attr0.x mul:4 ; encoding: [0x05,0x00,0x74,0xd2,0x00,0x04,0x02,0x10]


v_interp_p1lv_f16 v5, v2, attr1.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr1.x, v3 ; encoding: [0x05,0x00,0x75,0xd2,0x01,0x04,0x0e,0x04]

v_interp_p1lv_f16 v5, v2, attr0.z, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.z, v3 ; encoding: [0x05,0x00,0x75,0xd2,0x80,0x04,0x0e,0x04]

v_interp_p1lv_f16 v5, -v2, attr0.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, -v2, attr0.x, v3 ; encoding: [0x05,0x00,0x75,0xd2,0x00,0x04,0x0e,0x44]

v_interp_p1lv_f16 v5, v2, attr0.x, -v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, -v3 ; encoding: [0x05,0x00,0x75,0xd2,0x00,0x04,0x0e,0x84]

v_interp_p1lv_f16 v5, |v2|, attr0.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, |v2|, attr0.x, v3 ; encoding: [0x05,0x02,0x75,0xd2,0x00,0x04,0x0e,0x04]

v_interp_p1lv_f16 v5, v2, attr0.x, |v3|
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, |v3| ; encoding: [0x05,0x04,0x75,0xd2,0x00,0x04,0x0e,0x04]

v_interp_p1lv_f16 v5, v2, attr0.x, v3 high
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, v3 high ; encoding: [0x05,0x00,0x75,0xd2,0x00,0x05,0x0e,0x04]

v_interp_p1lv_f16 v5, v2, attr0.x, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, v3 clamp ; encoding: [0x05,0x80,0x75,0xd2,0x00,0x04,0x0e,0x04]

v_interp_p1lv_f16 v5, v2, attr0.x, v3 mul:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, v3 mul:2 ; encoding: [0x05,0x00,0x75,0xd2,0x00,0x04,0x0e,0x0c]

v_interp_p1lv_f16 v5, v2, attr0.x, v3 div:2
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p1lv_f16 v5, v2, attr0.x, v3 div:2 ; encoding: [0x05,0x00,0x75,0xd2,0x00,0x04,0x0e,0x1c]


v_interp_p2_f16 v5, v2, attr1.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr1.x, v3 ; encoding: [0x05,0x00,0x76,0xd2,0x01,0x04,0x0e,0x04]

v_interp_p2_f16 v5, v2, attr32.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr32.x, v3 ; encoding: [0x05,0x00,0x76,0xd2,0x20,0x04,0x0e,0x04]

v_interp_p2_f16 v5, v2, attr0.w, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr0.w, v3 ; encoding: [0x05,0x00,0x76,0xd2,0xc0,0x04,0x0e,0x04]

v_interp_p2_f16 v5, -v2, attr0.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, -v2, attr0.x, v3 ; encoding: [0x05,0x00,0x76,0xd2,0x00,0x04,0x0e,0x44]

v_interp_p2_f16 v5, v2, attr0.x, -v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr0.x, -v3 ; encoding: [0x05,0x00,0x76,0xd2,0x00,0x04,0x0e,0x84]

v_interp_p2_f16 v5, |v2|, attr0.x, v3
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, |v2|, attr0.x, v3 ; encoding: [0x05,0x02,0x76,0xd2,0x00,0x04,0x0e,0x04]

v_interp_p2_f16 v5, v2, attr0.x, |v3|
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr0.x, |v3| ; encoding: [0x05,0x04,0x76,0xd2,0x00,0x04,0x0e,0x04]

v_interp_p2_f16 v5, v2, attr0.x, v3 high
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr0.x, v3 high ; encoding: [0x05,0x00,0x76,0xd2,0x00,0x05,0x0e,0x04]

v_interp_p2_f16 v5, v2, attr0.x, v3 clamp
// NOSICI: :[[@LINE-1]]:{{[0-9]+}}: error: instruction not supported on this GPU
// VI: v_interp_p2_f16 v5, v2, attr0.x, v3 clamp ; encoding: [0x05,0x80,0x76,0xd2,0x00,0x04,0x0e,0x04]
