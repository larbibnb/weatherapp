class LlmWeatherStates {}

class LlmWeatherInitial extends LlmWeatherStates {}

class LlmWeatherLoading extends LlmWeatherStates {}

class LlmWeatherSuccess extends LlmWeatherStates {
  final String description;

  LlmWeatherSuccess({required this.description});
}

class LlmWeatherFailure extends LlmWeatherStates {
  final String errorMessage;

  LlmWeatherFailure({required this.errorMessage});
}
