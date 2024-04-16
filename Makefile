TARGET		=		paq

FLAGS_PROD	=		-cc gcc \
					-os linux \
					-gc none \
					-cflags '-fPIC -march=x86-64 -mtune=generic' \
					-prod \
					-obf \

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v . \
		$(FLAGS_PROD)

$(TARGET)-prod-upx:
	v . \
		$(FLAGS_PROD) \
		-compress

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
