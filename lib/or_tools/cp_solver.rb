require "forwardable"

module ORTools
  class CpSolver
    extend Forwardable

    def_delegators :@response, :objective_value, :num_conflicts, :num_branches, :wall_time

    def solve(model, observer = nil)
      @response = _solve(model, parameters, observer)
      @response.status
    end

    def value(var)
      if var.is_a?(BoolVar)
        _solution_boolean_value(@response, var)
      else
        _solution_integer_value(@response, var)
      end
    end

    def solve_with_solution_callback(model, observer)
      warn "[or-tools] solve_with_solution_callback is deprecated; use solve() with the callback argument."
      solve(model, observer)
    end

    def search_for_all_solutions(model, observer)
      warn "[or-tools] search_for_all_solutions is deprecated; use solve() with enumerate_all_solutions = true."
      parameters.enumerate_all_solutions = true
      solve(model, observer)
    end

    def sufficient_assumptions_for_infeasibility
      @response.sufficient_assumptions_for_infeasibility
    end

    def parameters
      @parameters ||= SatParameters.new
    end
  end
end
