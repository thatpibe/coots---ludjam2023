extends CootsState

func physics_process(delta: float) -> int:
	if coots.global_position.x <= coots.LEFT_BOUND:
		return State.WalkTurnedRight

	return State.Null
