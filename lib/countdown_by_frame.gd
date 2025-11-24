extends RefCounted

class_name CountdownByFrame

class countdownEntry:
	var maxCooldown: float
	var currentCooldown: float
	var isEnable: bool
	var isTimeout: bool
	
	func _init(maxCd, enable):
		self.maxCooldown = maxCd
		self.currentCooldown = 0
		self.isEnable = enable
		self.isTimeout = false
	
	func Update(_delta: float):
		if !isEnable or isTimeout:
			return

		self.currentCooldown -= _delta
		if self.currentCooldown <= 0:
			# At least timed out once
			self.isTimeout = true
			self.currentCooldown = self.maxCooldown
	
	func IsTrigger():
		if self.isTimeout:
			self.isTimeout = false
			return true
		return false
	
	func Reset():
		self.currentCooldown = 0
		
	func SetEnable(enable: bool):
		self.isEnable = enable


var allCountdown: Dictionary[String, countdownEntry] = {}


func RegisterNewCountdown(name: String, cooldown: float, enable: bool):
	assert(!allCountdown.has(name), "duplicated countdown")
	allCountdown.set(name, countdownEntry.new(cooldown, enable))


func Update(_delta: float):
	for k in allCountdown.keys():
		allCountdown[k].Update(_delta)


func IsTrigger(name: String):
	assert(allCountdown.has(name), "countdown not exist")
	return allCountdown[name].IsTrigger()


func ResetCountdown(name: String):
	assert(allCountdown.has(name), "countdown not exist")
	allCountdown[name].Reset()


func SetEnable(name: String, enable: bool):
	assert(allCountdown.has(name), "countdown not exist")
	allCountdown[name].SetEnable(enable)
