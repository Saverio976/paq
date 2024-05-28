TARGET		=		paq

CRI			?=		podman

FLAGS_PROD	=		-os linux \
					-gc none \
					-cflags '-fPIC -march=x86-64 -mtune=generic' \
					-prod \
					-obf

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v . \
		$(FLAGS_PROD)

$(TARGET)-release:
	v . \
		$(FLAGS_PROD) \
		-skip-unused \
		-compress \
		-cflags '-static'

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

clean:

fclean: clean
	$(RM) $(TARGET)
