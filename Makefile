TARGET		=		paq

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v \
		-os linux \
		-o "$(TARGET)" \
		-gc none \
		-skip-unused \
		-ldflags '-static' \
		-ldflags '-static-libgcc' \
		-cflags '-fPIC -static' \
		-prod \
		.

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
