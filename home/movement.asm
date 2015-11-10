InitMovementBuffer:: ; 1b1e
	ld [wMovementBufferPerson], a
	xor a
	ld [wMovementBufferCount], a
	ld a, $0 ; useless
	ld [wd004], a
	ld a, $7
	ld [wd005], a
	ld a, $d0
	ld [wd006], a
	ret
; 1b35

DecrementMovementBufferCount:: ; 1b35
	ld a, [wMovementBufferCount]
	and a
	ret z
	dec a
	ld [wMovementBufferCount], a
	ret
; 1b3f

AppendToMovementBuffer:: ; 1b3f
	push hl
	push de
	ld hl, wMovementBufferCount
	ld e, [hl]
	inc [hl]
	ld d, 0
	ld hl, MovementBuffer
	add hl, de
	ld [hl], a
	pop de
	pop hl
	ret
; 1b50

AppendToMovementBufferNTimes:: ; 1b50
	push af
	ld a, c
	and a
	jr nz, .okay
	pop af
	ret

.okay
	pop af
.loop
	call AppendToMovementBuffer
	dec c
	jr nz, .loop
	ret
; 1b5f

ComputePathToWalkToPlayer:: ; 1b5f
	push af
; compare x coords, load left/right into h, and x distance into d
	ld a, b
	sub d
	ld h, LEFT
	jr nc, .got_x_distance
	dec a
	cpl
	ld h, RIGHT

.got_x_distance
	ld d, a
; compare y coords, load up/down into l, and y distance into e
	ld a, c
	sub e
	ld l, UP
	jr nc, .got_y_distance
	dec a
	cpl
	ld l, DOWN

.got_y_distance
	ld e, a
; if the x distance is less than the y distance, swap h and l, and swap d and e
	cp d
	jr nc, .done
	ld a, h
	ld h, l
	ld l, a
	ld a, d
	ld d, e
	ld e, a

.done
	pop af
	ld b, a
; Add movement in the longer direction first...
	ld a, h
	call .GetMovementData
	ld c, d
	call AppendToMovementBufferNTimes
; ... then add the shorter direction.
	ld a, l
	call .GetMovementData
	ld c, e
	call AppendToMovementBufferNTimes
	ret
; 1b92

.GetMovementData: ; 1b92
	push de
	push hl
	ld l, b
	ld h, 0
rept 2
	add hl, hl
endr
	ld e, a
	ld d, 0
	add hl, de
	ld de, .MovementData
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	ret
; 1ba5

.MovementData
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right
	step_down
	step_up
	step_left
	step_right
	big_step_down
	big_step_up
	big_step_left
	big_step_right
; 1bb1

Function1bb1:: ; 1bb1
	push hl
	push bc
	ld hl, wcfa1
	ld b, $8
.asm_1bb8
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_1bb8
	ld a, $1
rept 2
	ld [hli], a
endr
	xor a
rept 3
	ld [hli], a
endr
	pop bc
	pop hl
	ret
; 1bc9

Function1bc9:: ; 1bc9
	callab Function241a8
	call Function1bdd
	ret
; 1bd3

Function1bd3:: ; 1bd3
	callab Function241ab
	call Function1bdd
	ret
; 1bdd

Function1bdd:: ; 1bdd
	push bc
	push af
	ld a, [hJoyLast]
	and D_PAD
	ld b, a
	ld a, [hJoyPressed]
	and BUTTONS
	or b
	ld b, a
	pop af
	ld a, b
	pop bc
	ret
; 1bee

Function1bee:: ; 1bee
	ld hl, wcfac
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $ec
	ret
; 1bf7

Function1bf7:: ; 1bf7
	ld hl, wcfac
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $7f
	ret
; 1c00

