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
		-ldflags '-static -static-libgcc' \
		-cflags '-fPIC -static -march=x86-64 -mtune=generic' \
		.

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
