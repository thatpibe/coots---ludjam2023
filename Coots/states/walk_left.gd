extends CootsState

func physics_process(delta: float) -> int:
	if coots.position.x <= coots.LEFT_BOUND:
		return State.WalkRight

	return State.Null
