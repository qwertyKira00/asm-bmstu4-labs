#include <stdio.h>
#include <stdlib.h>
#define OK 0
#define ERROR -1
#define READ 1
#define ADD '+'
#define SUB '-'
#define MUL '*'
#define DIV '/'
#define SCALE '^'
#define EXIT '0'
#define WRONG_OPERATOR 1

double calc_addition(double a, double b)
{
	double result; 

	asm(".intel_syntax noprefix\n\t"
		"fld %1\n\t"					//st(1) = а;
		"fld %2\n\t"					//st(0) = b;
		"fadd st(1)\n\t"				//st(0) = st(0) + st(1)
		"fst %0\n\t"
		: "=m"(result)
		: "m"(a), "m"(b)
		);

	return result;
}

double calc_subtraction(double a, double b)
{
	double result; 

	asm(".intel_syntax noprefix\n\t"
		"fld %1\n\t"					//st(1) = а;
		"fld %2\n\t"					//st(0) = b;
		"fxch st(1)\n\t"
		"fsub st(1)\n\t"				//st(0) = st(0) - st(1)
		"fst %0\n\t"
		: "=m"(result)
		: "m"(a), "m"(b)
		);

	return result;
}

double calc_multiplication(double a, double b)
{
	double result; 

	asm(".intel_syntax noprefix\n\t"
		"fld %1\n\t"					//st(1) = а;
		"fld %2\n\t"					//st(0) = b;
		"fmul st(1)\n\t"				//st(0) = st(1) * st(0),
		"fst %0\n\t"
		: "=m"(result)
		: "m"(a), "m"(b)
		);

	return result;
}

double calc_division(double a, double b)
{
	double result; 

	asm(".intel_syntax noprefix\n\t"
		"fld %1\n\t"					//st(1) = а;
		"fld %2\n\t"					//st(0) = b;
		"fdivp\n\t"						//st(1) = st(1) / st(0),
		"fst %0\n\t"
		: "=m"(result)
		: "m"(a), "m"(b)
		);

	return result;
}

double calc_scale(double a, double b)
{
	double result; 

	asm(".intel_syntax noprefix\n\t"
		"fld %1\n\t"					//st(1) = а;
		"fld %2\n\t"					//st(0) = b;
		"fscale\n\t"					//ST(0) умножается на 2^ST(1)
		"fst %0\n\t"
		: "=m"(result)
		: "m"(a), "m"(b)
		);

	return result;
}

int ReadNumb(double *x)
{
	printf("Enter the number: ");
	if (scanf("%lf", x) != READ)
	{
		printf("Incorrect input\n");
		return ERROR;
	}
	return READ;
}

void clean(void)
{
	scanf("%*[^\n]");
	scanf("%*c");
}

int ReadOperator(char *x)
{
	printf("Enter the operator sign: ");
	clean();
	if (scanf("%c", x) != READ)
	{
		printf("Incorrect input\n");
		return ERROR;
	}
	return READ;
}

int ReadParameters(double *a, double *b, char *operator)
{
	if (ReadNumb(a) == ERROR)
		return ERROR;
	if (ReadNumb(b) == ERROR)
		return ERROR;
	if (ReadOperator(operator) == ERROR)
		return ERROR;
	if (*operator == '0')
		return READ;

	return READ;
}

int main(void)
{
	double a, b;
	char operator;
	int rc = 0;

	if (ReadParameters(&a, &b, &operator) == ERROR)
		return ERROR;
	
	while (operator != EXIT)
	{
		switch (operator)
		{
			case ADD:
				printf("Result = %lf\n\n", calc_addition(a, b));
				break;
			case SUB:
				printf("Result = %lf\n\n", calc_subtraction(a, b));
				break;
			case MUL:
				printf("Result = %lf\n\n", calc_multiplication(a, b));
				break;
			case DIV:
				printf("Result = %lf\n\n", calc_division(a, b));
				break;
			case SCALE:
				printf("Result = %lf\n\n", calc_scale(a, b));
				break;
			case EXIT:
				break;
			default:
				rc = WRONG_OPERATOR;
				break;
		}
		
		if (rc == WRONG_OPERATOR)
		{
			printf("Incorrect operator\n");
			return ERROR;
		}
		if (ReadParameters(&a, &b, &operator) == ERROR)
			return ERROR;
	}
	
	return OK;
}