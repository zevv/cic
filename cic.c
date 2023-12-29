#include <stdio.h>
#include <stdint.h>
#include <math.h>

struct integrator {
	int v;
};

void integrator_init(struct integrator *i)
{
	i->v = 0;
}

int integrator_run(struct integrator *i, int v)
{
	i->v += v;
	return i->v;
}

struct comb {
	int vp;
};


void comb_init(struct comb *c)
{
	c->vp = 0;
}


int comb_run(struct comb *c, int v)
{
	int result = v - c->vp;
	c->vp = v;
	return result;
}

struct integrator in[8];
struct comb c[8];

void init(void)
{
	for(int i=0; i<8; i++) {
		integrator_init(&in[i]);
		comb_init(&c[i]);
	}

}

#define N 2
#define R 48

void emit(double v, float vorg)
{
	static FILE *f = NULL;
	if(f == NULL) f = fopen("/tmp/d", "w");

	for(int i=0; i<N; i++) {
		v = integrator_run(&in[i], v);
	}


	static int n = 0;
	if(++n == R) {
		n = 0;
		for(int i=0; i<N; i++) {
			v = comb_run(&c[i], v);
		}
		fprintf(f, "%f %f\n", vorg, (double) v / pow(R, N));
	}


}


void pdm(double *y)
{
	static double out[16];
	static double intg[16];

	for(int i=0; i<48; i++) {
		
		for(int j=0; j<16; j++) {
			intg[j] += y[j];
			out[j] = (intg[j] > 0.0) ? +1.0 : -1.0;
			intg[j] -= out[j];
		}
		
		printf("#5\n");
		for(int j=0; j<16; j+=2) {
			printf("din[%d] = %d;\n", j<2, out[j] > 0 ? 1 : 0);
		}

		printf("#15\n");
		for(int j=0; j<16; j+=2) {
			printf("din[%d] = 1'dx;\n", j<2);
		}

		printf("#5\n");
		for(int j=1; j<16; j+=2) {
			printf("din[%d] = %d;\n", j<2, out[j] > 0 ? 1 : 0);
		}
		
		printf("#15\n");
		for(int j=0; j<16; j+=2) {
			printf("din[%d] = 1'dx;\n", j<2);
		}

		//printf(" # 10 din = 1'dx;\n");
		//printf(" # 10 din = %d;\n", out1 > 0 ? 1 : 0);
		//printf(" # 10 din = 1'dx;\n");
		//emit(out0, out1, v0, v1);
		//printf("%f %f\n", out, v);
	}
}


int main(int argc, char **argv)
{
	init();

	double t = 0;
	for(int i=0; i<80; i++) {
		double y[16];
		for(int j=0; j<16; j++) {
			y[j] = cos(t * 2 * M_PI * (((j * 23123123) % 2000) + 100));
		}
		pdm(y);
		//y = cos(t * 2 * M_PI * 100) * 0.5;
		t += 1/8000.0;
	}
	return 0;
}
