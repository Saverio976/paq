TARGET		=		paq

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v \
		-cross \
		-os linux \
		-o "$(TARGET)" \
		-gc none \
		-skip-unused \
		-ldflags '-static' \
		-ldflags '-static-libgcc' \
		-cflags '-fPIC' \
		-prod \
		.

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
