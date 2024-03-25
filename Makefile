TARGET		=		paq

all: $(TARGET)

$(TARGET):
	v . -o $(TARGET)

$(TARGET)-prod:
	v -os linux -o "$(TARGET)" -skip-unused -ldflags '-static' -prod .

.PHONY: $(TARGET) $(TARGET)-prod

format:
	v fmt -w .

fclean: clean
	"$(RM)" $(TARGET)
