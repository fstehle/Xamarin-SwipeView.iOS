using System;
using MonoTouch.ObjCRuntime;

[assembly: LinkWith ("libSwipeView.a", LinkTarget.Simulator | LinkTarget.ArmV7 | LinkTarget.ArmV7s, 
	ForceLoad = true, Frameworks = "Foundation")]
