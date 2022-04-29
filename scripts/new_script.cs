using Godot;
using System;

public class new_script : Node
{
	private string a = "Hello";

	public override void _Ready()
	{
		GD.Print(a);
	}
}
