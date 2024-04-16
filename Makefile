TARGET		=		paq

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v \
		-cc gcc \
		-os linux \
		-o "$(TARGET)" \
		-gc none \
		-cflags '-fPIC -march=x86-64 -mtune=generic' \
		-prod \
		$$(command -v upx 2>/dev/null && echo "-compress" || echo "") \
		-obf \
		.

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
