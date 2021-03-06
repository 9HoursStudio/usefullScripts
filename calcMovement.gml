/// @function						calcMove()
/// @description					calculates next ax/ay, variables that then can be used to calculate next x and y positions
/// @description					_xn force applied over x axis that will be added to ax
/// @description					_yn force applied over y axis that will be added to ay
/// @description					_maxspd maxmimun speed that the object cant reach
/// @description					_acc object acceleration value
/// @description					_brake deceleration value
/// @description					_ox initial position of ax, this is used just for debug to show on screen the values of ax and ay moving the origin of this variable
/// @description					_oy initial position of ay, this is used just for debug to show on screen the values of ax and ay moving the origin of this variable
/// @param							_xn
/// @param							_yn
/// @param							_maxspd
/// @param							_acc
/// @param							_brake
/// @param							_ox
/// @param							_oy

function calcMove(_xn, _yn, _maxspd, _acc, _brake, _ox, _oy){
	
	
	_maxspd = is_undefined(_maxspd) ? 2 : _maxspd
	_acc = is_undefined(_acc) ? 0.1 : _acc
	_brake = is_undefined(_brake) ? 0.1 : _brake
	_ox = is_undefined(_ox) ? 0 : _ox
	_oy = is_undefined(_oy) ? 0 : _oy


	if _xn != 0 or _yn != 0 {
	
		var dx = _xn - _ox
		var dy = _yn - _oy
		var d = sqrt(power(dx, 2) + power(dy, 2))
	
		var ddx = ax - _ox
		var ddy = ay - _oy
		var dd = sqrt(power(ddx, 2) + power(ddy, 2))
		
		if dd < _maxspd or d < dd { // if force x/y is below maxspd limit
		
			var dxn = _xn - ax
			var dyn = _yn - ay
			var dn = sqrt(power(dxn, 2) + power(dyn, 2))
		
			if dn >= _acc { // avoids flickering when ax/ay is close to force x/y but not equal
		
				if d > dd { // if force is further to the origin that ax/ay
		
					ax += _acc * dx / d
					ay += _acc * dy / d
		
				} else { // if force is closer to the origin that ax/ay
			
					ax += _acc * dxn / dn
					ay += _acc * dyn / dn 
			
				}
			} else {
			
				ax = _xn
				ay = _yn
						
			}
		
		} else { // if force is over the maxspd limit
		
			var zettaAngle = point_direction(_ox,_oy,_xn,_yn)
			var alphaAngle = point_direction(_ox,_oy,ax,ay)
		
			var  angleDifference = zettaAngle - alphaAngle
			var angAcc = 100 * _acc
		
			if abs(angleDifference) >= angAcc {
			
				if abs(angleDifference) < 180 {
					ax = _maxspd * dcos(alphaAngle + angAcc * sign(angleDifference)) + _ox
					ay = _maxspd * -dsin(alphaAngle + angAcc * sign(angleDifference)) + _oy
				} else {
					
					if abs(angleDifference) == 180 {
						
						ax += _acc * dx / d
						ay += _acc * dy / d
						
					} else {
						ax = _maxspd * dcos(alphaAngle +  angAcc * -sign(angleDifference)) + _ox
						ay = _maxspd * -dsin(alphaAngle + angAcc * -sign(angleDifference)) + _oy
					}
	
				}
		
			} else {
			
				ax += _acc * dx / d
				ay += _acc * dy / d
			
			}
		
			
		}
		

	} else { // if force not applied over object, ax/ay go back to their origin
	
	
		var ddx = ax - _ox
		var ddy = ay - _oy
		var dd = sqrt(power(ddx, 2) + power(ddy, 2))
	
		if dd >= _brake {

			ax -= _brake * ddx / dd
			ay -= _brake * ddy / dd
	
		} else {
		
			ax = _ox
			ay = _oy
		
		}
	
	}

}
