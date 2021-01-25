#pragma once

#include <bitset>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <memory>
#include <random>
#include <set>
#include <vector>



namespace ga
{



namespace utility
{

class Observer
{
public:
  virtual ~Observer() {}

  virtual void Update() = 0;
};


class Observable
{
public:
  void Attach(Observer* obs) { observers.insert(obs); }
  void Detatch(Observer* obs) { observers.erase(obs); }
  
  void Notify() { for (auto& obs : observers) { obs->Update(); } }

private:
  std::set<Observer*> observers;
};


}; // namespace util



template <typename InputType>
class Population
{
public:

  Population() {}

  template <typename GeneratorFunction>
  Population(size_t size, GeneratorFunction& gen)
  {
    individuals.resize(size);
    for (auto& p : individuals) { p = gen(); }
  }

  void Print() {
    for (auto& p : individuals) {
      std::cout << p << std::endl;
    }
  }

  size_t Size() const { return individuals.size(); }
  InputType GetIndividual(size_t individual_num) const { return individuals[individual_num]; }
  double GetFitness(size_t individual_num) const { return fitness[individual_num]; }
  InputType GetBestIndividual() const { return individuals[best_individual]; }
  double GetBestFitness() const { return best_fitness; }
  
  size_t AddIndividual(const InputType& ind)
  {
    individuals.push_back(ind);
    return individuals.size();
  }
  
  size_t AddIndividuals(const std::vector<InputType>& inds)
  {
    for (auto& i : inds) {
      individuals.push_back(i);
    }
    return individuals.size();
  }


  template <typename FitnessFunction>
  std::pair<int, double> Evaluate(FitnessFunction f) // I don't love having to pass the function here...
  {
    best_individual = 0;
    best_fitness = f(individuals.front());
    
    fitness.clear();
    fitness.reserve(individuals.size());

    for (size_t ind = 0; ind < individuals.size(); ++ind) {
      double this_fitness = f(individuals[ind]);
      if (this_fitness > best_fitness) {
        best_fitness = this_fitness;
        best_individual = ind;
      }
      fitness.push_back(this_fitness);
    }
    return std::make_pair(best_individual, best_fitness);
  }

private:
  std::vector<InputType> individuals;
  std::vector<double>    fitness;

  double best_fitness;
  size_t best_individual;
};




template <typename InputType>
class CrossoverAlgorithm
{
public:
  virtual std::vector<InputType> Recombine(const Population<InputType>& pop,
                                           const std::vector<size_t>& mates) const = 0;
};




template <typename InputType>
class RandomCrossover : public CrossoverAlgorithm<InputType>
{
public:
  RandomCrossover(double rate_use)
    : rng_mt((std::random_device())()),
      rate(rate_use)
  {}
    
  std::vector<InputType> Recombine(const Population<InputType>& pop,
                                   const std::vector<size_t>& mates) const override
  {
    // can this work with more than 2 input values?

    // TODO Check size of input
    InputType one = pop.GetIndividual(mates[0]);
    InputType two = pop.GetIndividual(mates[1]);

    uint8_t* a = (uint8_t*)&one;
    uint8_t* b = (uint8_t*)&two;

    for (size_t i = 0; i < sizeof(InputType); ++i) {
      SwapRandomBits(*a, *b);
      ++a;
      ++b;
    }

    return std::vector<InputType>{one, two};
  }

private:
  mutable std::mt19937 rng_mt;
  double rate;

  void SwapRandomBits(uint8_t& a, uint8_t& b) const
  {
    std::uniform_int_distribution<int> id(0, 1);

    std::bernoulli_distribution bd(rate);

    uint8_t mask = 0x00;
    for (int i = 0; i < 8; ++i) {
      mask <<= 1;
      if (bd(rng_mt)) {
        mask |= 1;
      }
    }

    uint8_t c = (a & ~mask) | (b & mask);
    uint8_t d = (a & mask) | (b & ~mask);

    a = c;
    b = d;
  }
};


template <typename InputType>
class SelectionAlgorithm
{
public:
  // return a set of N unique indexes of individuals from the population
  virtual std::vector<size_t> Select(size_t N, const Population<InputType>& pop) const = 0;
};



template <typename InputType>
class TournamentSelection : public SelectionAlgorithm<InputType>
{
public:
  TournamentSelection(size_t tournament_size_use)
    : rng_mt((std::random_device())()),
      tournament_size(tournament_size_use)
  {}
  
  std::vector<size_t> Select(size_t N, const Population<InputType>& pop) const override
  {
    std::uniform_int_distribution<int> idist(0, pop.Size() - 1);
    std::set<size_t> winners;

    while (winners.size() < N) {
      // run a tournament
      auto winner = idist(rng_mt);
      double best_fitness = pop.GetFitness(winner);
      std::set<size_t> losers;

      while (losers.size() < tournament_size - 1) {
        auto competitor = idist(rng_mt);
        double comp_fitness = pop.GetFitness(competitor);
        if (comp_fitness > best_fitness) {
          best_fitness = comp_fitness;
          losers.insert(winner);
          winner = competitor;
        } else {
          losers.insert(competitor);
        }
      }
      winners.insert(winner);
    }

    return std::vector<size_t>(winners.begin(), winners.end());
  }


private:
  mutable std::mt19937 rng_mt;
  size_t tournament_size;
};


template <typename InputType>
class MutationOperator
{
public:
  MutationOperator(double rate_use)
    : rng_mt((std::random_device())()),
      rate(rate_use)
  {}
  
  void Mutate(InputType& data) const
  {
    uint8_t* ptr = (uint8_t*)&data;
    for (size_t i = 0; i < sizeof(InputType); ++i) {
      FlipSomeBits(*ptr);
      ++ptr;
    }
  }

private:
  mutable std::mt19937 rng_mt;
  double rate;

  void FlipSomeBits(uint8_t& data) const
  {
    std::uniform_real_distribution<double> rd(0, 1);
    uint8_t mask = 0x01;

    for (int i = 0; i < 8; ++i) {
      if (rd(rng_mt) < rate) {
        data ^= mask;
      }
      mask <<= 1;
    }
  }
};



template <typename InputType>
class PopulationUpdateAlgorithm
{
  using PopulationType = Population<InputType>;
public:
  virtual PopulationType UpdatePopulation(const PopulationType& input_pop) const = 0;
};



template <typename InputType>
class ReplacePopulationAlgorithm : public PopulationUpdateAlgorithm<InputType>
{
  using PopulationType = Population<InputType>;

public:
  ReplacePopulationAlgorithm()
    : selection_algorithm(std::make_unique<TournamentSelection<InputType>>(3)), // TODO add params for the values passed to the constructors
      crossover_algorithm(std::make_unique<RandomCrossover<InputType>>(0.1)),
      mutation_operator(std::make_unique<MutationOperator<InputType>>(0.005))
  {}
  
  PopulationType UpdatePopulation(const PopulationType& input_pop) const override
  {
    size_t max_size = input_pop.Size();
    PopulationType new_pop;

    while (new_pop.Size() < max_size) {
      auto ind = selection_algorithm->Select(2, input_pop);
      auto new_ind = crossover_algorithm->Recombine(input_pop, ind);

      for (auto& p : new_ind) {
        mutation_operator->Mutate(p);
      }
      new_pop.AddIndividuals(new_ind);
    }

    return new_pop;
  }

private:
  std::unique_ptr<SelectionAlgorithm<InputType>> selection_algorithm;
  std::unique_ptr<CrossoverAlgorithm<InputType>> crossover_algorithm;
  std::unique_ptr<MutationOperator<InputType>>   mutation_operator;
};



template <typename InputType>
class GeneticAlgorithm : public utility::Observable
{
public:
  GeneticAlgorithm()
    : update_algorithm(std::make_unique<ReplacePopulationAlgorithm<InputType>>()),
      total_generations(0)
  {}

  template <typename GeneratorFunction>
  void InitializePopulation(size_t size, GeneratorFunction& gen)
  {
    population = Population<InputType>(size, gen);
  }

  template <typename FitnessFunction>
  void Evolve(int num_generations, FitnessFunction fitness_function)
  {
    population.Evaluate(fitness_function);
    Notify();
    
    for (int generation = 0; generation < num_generations; ++generation) {
      population = update_algorithm->UpdatePopulation(population);
      population.Evaluate(fitness_function);
      ++total_generations;
      Notify();
    }
  }

  double GetBestFitness() const { return population.GetBestFitness(); }
  InputType GetBestIndividual() const { return population.GetBestIndividual(); }
  size_t GetTotalGenerations() const { return total_generations; }

private:
  Population<InputType> population;
  std::unique_ptr<PopulationUpdateAlgorithm<InputType>> update_algorithm;
  size_t total_generations;
};



template <typename InputType>
class GAStats : public utility::Observer
{
public:
  GAStats(const GeneticAlgorithm<InputType>& ga_use)
    : gen_alg(ga_use)
  {}
  
  virtual void Update() override
  {
    std::cout << gen_alg.GetTotalGenerations() << "\t"
              << gen_alg.GetBestFitness() << "\t"
              << gen_alg.GetBestIndividual() << std::endl;
  }

public:
  const GeneticAlgorithm<InputType>& gen_alg;
};




}; // namespace ga
