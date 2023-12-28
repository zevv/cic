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

void emit(int v, float vorg)
{
	for(int i=0; i<N; i++) {
		v = integrator_run(&in[i], v);
	}

	static int n = 0;
	if(++n == R) {
		n = 0;
		for(int i=0; i<N; i++) {
			v = comb_run(&c[i], v);
		}
		//printf("%f %f\n", vorg, (double) v / pow(R, N));
	}


}


void pdm(double v)
{
	static double out = 0.0;
	static double integrator = 0.0;

	for(int i=0; i<64; i++) {
		integrator += v;
		out = (integrator > 0.0) ? +1.0 : -1.0;
		printf(" # 1 din = %d;\n", out > 0 ? 1 : 0);
		emit(out, v);
		//printf("%f %f\n", out, v);
		integrator -= out;
	}
}


int main(int argc, char **argv)
{
	init();

	double t = 0;
	for(int i=0; i<80; i++) {
		double y = cos(t * 2 * M_PI * 21) * 0.5 + sin(t * 2 * M_PI * 100) * 0.3;
		//y = cos(t * 2 * M_PI * 100) * 0.5;
		t += 1/8000.0;
		pdm(y);
	}
	return 0;
}
