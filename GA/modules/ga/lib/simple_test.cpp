#include "ga.hpp"
#include <random>

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

int main_new(void)
{
	GATask* gTask = new GATask(8, 7.15, 2.22, 8.4, 6.07);
	//for (int i = 0; i < 100; i++)
	//{
	gTask->Eva();
	gTask->Update();
	//}
	gTask->Eva();

	Test BestForNow = gTask->GetBest();
	return int(std::round(BestForNow.a));
}

int main_old(void)
{
	ga::GeneticAlgorithm<Test> GA;
	//ga::GAStats<Test> ga_stats(GA);

	//GA.Attach(&ga_stats);
	TestGenerator gen;
	// TestEvaluator test(3.01, -4.114, 2.121121, 0.0007);
	TestEvaluator test(7.15, 2.22, 8.4, 6.07);

	GA.InitializePopulation(200, gen);
	//GA.Evolve(1000, test);
	GA.population.Evaluate(test);
	//GA.Notify();

	GA.population = GA.update_algorithm->UpdatePopulation(GA.population);
	GA.population.Evaluate(test);
	//GA.Notify();
	return 20291224;
}
