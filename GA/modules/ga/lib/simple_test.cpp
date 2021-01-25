#include "ga.hpp"

#include <random>

struct Test
{
	double a;
	double b;
	double c;
	double d;
};

std::ostream& operator<<(std::ostream& out, const Test& t)
{
	out << "{ "
		<< std::setw(10) << std::fixed << std::setprecision(6) << t.a << ", "
		<< std::setw(10) << std::fixed << std::setprecision(6) << t.b << ", "
		<< std::setw(10) << std::fixed << std::setprecision(6) << t.c << ", "
		<< std::setw(10) << std::fixed << std::setprecision(6) << t.d
		<< " }";
	return out;
}

class TestGenerator
{
public:
	TestGenerator() : rng_mt{ std::random_device{}() } {}

	Test operator()()
	{
		std::uniform_real_distribution<double> ddist(-100, 100);

		return Test{
			ddist(rng_mt),
			ddist(rng_mt),
			ddist(rng_mt),
			ddist(rng_mt)
		};
	};

private:
	std::mt19937 rng_mt;

};

class TestEvaluator
{
public:
	TestEvaluator(double x, double y, double z, double w)
		: A(x), B(y), C(z), D(w) {}

	double operator()(const Test& t)
	{
		return -(std::pow(t.a - A, 2.0)
			+ std::pow(t.b - B, 2.0)
			+ std::pow(t.c - C, 2.0)
			+ std::pow(t.d - D, 2.0)
			);
	}

private:
	double A, B, C, D;
};

int main(void)
{
	ga::GeneticAlgorithm<Test> GA;
	ga::GAStats<Test> ga_stats(GA);

	GA.Attach(&ga_stats);
	TestGenerator gen;
	// TestEvaluator test(3.01, -4.114, 2.121121, 0.0007);
	TestEvaluator test(7.15, 2.22, 8.4, 6.07);

	GA.InitializePopulation(20000, gen);
	//GA.Evolve(1000, test);
	GA.population.Evaluate(test);
	GA.Notify();

	GA.population = GA.update_algorithm->UpdatePopulation(GA.population);
	GA.population.Evaluate(test);
	GA.Notify();
}
