.code16
.org 0x7c00

_start:

# Setup a stack (almost essential)
	cli
		# Not safe to switch stack if interrupts enabled
	xorw %ax, %ax
		# Idiom to zero register AX
	movw %ax, %ss
		# Set SS=0
	movw $_start, %sp
		# Stack grows down beneath our start address
	push %ss
	pop %es
		# Copy SS register to ES
	push %ss
	pop %ds
		# Same for DS register
	sti
		# Now we can re-enable interrupts

# Clear the screen
	movw $0x0003, %ax
		# Set video mode 3
		# Which we already should be in anyway
	int $0x10

# Go to home position
	movw $0x0002, %ax
	xorw %bx, %bx
	xorw %dx, %dx
	int $0x10

# Display our message
	movw $msg, %di
	call print_msg

# Infinite halt loop we don't have any code to do anything else yet
loop:
	hlt
	jmp loop

print_msg:
	movb (%di), %al
	andb %al, %al
		# Sets flags from %al
	jz print_msg_exit
	push %di
		# Save %di register
	call print_al
		# Consumes %al
	pop %di
		# Restore %di register
	inc %di
	jmp print_msg
print_msg_exit:
	ret

# Print something (input: AL=character)
print_al:
	movb $0x0e, %ah
	xorw %bx, %bx
		# Use page 0
	int $0x10
	ret

# Message to display
msg:
.ascii "Welcome to DumbDOS!\r\nThe Dumbest Operating System Ever\r\n"
.ascii "\r\n"
.ascii "All it knows how to do...\r\n"
.ascii "...is display this message!\r\n\0"

# Generate the boot sector signature
# Due to x86 being little-endian, this is 0x55AA on disk but 0xAA55 in the code
.org 0x7dfe
bootsig:
.word 0xAA55
