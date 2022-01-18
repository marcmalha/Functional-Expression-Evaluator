##
## EPITECH PROJECT, 2021
## funEvalExpr
## File description:
## Wrapper of Stack build tool
##

NAME	=	funEvalExpr

STACK_PROJECT_NAME	=	$(NAME)

# ANSI color and ESCAPE sequences
COLOR	=		\x1b[1;31m
ESC		=		\x1b[0m

all:
	@echo "$(COLOR)Makefile: Building Project...$(ESC)"
	stack build
	@echo "$(COLOR)Makefile: Done$(ESC)"
	@echo "$(COLOR)Makefile: Moving executable from $(STACK_PROJECT_NAME) to root$(ESC)"
	stack --local-bin-path . install
	@echo "$(COLOR)Makefile: Done$(ESC)"

.PHONY:	run_tests
run_tests:
	stack test

.PHONY:	clean
clean:
	stack clean

.PHONY:	fclean
fclean:	clean
	rm -f $(NAME)

.PHONY:	re
re:	fclean	all