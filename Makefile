TARGET		=		paq

RM			=		rm

CFLAGS		=		-Wall \
					-Wextra \
					-Wpedantic \
					-Wdouble-promotion \
					-Wformat=2 \
					-Wformat-overflow=2 \
					-Wformat-truncation=2 \
					-Wnull-dereference \
					-ftabstop=4 \
					-Wmissing-include-dirs \
					-Wreturn-local-addr \
					-Wunused \
					-Wunused-const-variable=2 \
					-Wsuggest-attribute=noreturn \
					-Wsuggest-attribute=const \
					-Wduplicated-branches \
					-Wduplicated-cond \
					-Warray-bounds \
					-Wtrampolines \
					-Wshadow \
					-Wunsafe-loop-optimizations \
					-Wabsolute-value \
					-Wundef \
					-Wunused-macros \
					-Wbad-function-cast \
					-Wcast-align \
					-Wconversion \
					-Wdangling-else \
					-Wjump-misses-init \
					-Wmissing-prototypes \
					-Wnormalized=id \
					-Wredundant-decls \
					-Wnested-externs \
					-Wint-in-bool-context \
					-Wvla \
					-Wdisabled-optimization \
					-Wstack-protector \
					-fanalyzer \
					-O2 \
					-Isrc/tinylibc/includes

LDFLAGS		=		-Lsrc/tinylibc -ltinylibc -static

SRC			=		src/paq/main.c \
					src/paq/args.c

OBJ			=		$(SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJ) src/tinylibc/tinylibc.a
	cc $(OBJ) $(CFLAGS) $(LDFLAGS) -o $(TARGET)

src/tinylibc/tinylibc.a:
	"$(MAKE)" -C src/tinylibc

clean:
	"$(RM)" $(OBJ)

fclean: clean
	"$(RM)" $(TARGET)
