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


void pdm(double v0, double v1)
{
	static double out0 = 0.0;
	static double int0 = 0.0;
	static double out1 = 0.0;
	static double int1 = 0.0;

	for(int i=0; i<48; i++) {
		int0 += v0;
		out0 = (int0 > 0.0) ? +1.0 : -1.0;
		
		int1 += v1;
		out1 = (int1 > 0.0) ? +1.0 : -1.0;

		printf(" # 20 din = %d;\n", out0 > 0 ? 1 : 0);
		printf(" # 20 din = 1'dx;\n");
		printf(" # 20 din = %d;\n", out1 > 0 ? 1 : 0);
		printf(" # 20 din = 1'dx;\n");
		//emit(out0, out1, v0, v1);
		//printf("%f %f\n", out, v);
		int0 -= out0;
		int1 -= out1;
	}
}


int main(int argc, char **argv)
{
	init();

	double t = 0;
	for(int i=0; i<80; i++) {
		double y0 = cos(t * 2 * M_PI * 521);
		double y1 = sin(t * 2 * M_PI * 200);
		//y = cos(t * 2 * M_PI * 100) * 0.5;
		t += 1/8000.0;
		pdm(y0, y1);
	}
	return 0;
}
