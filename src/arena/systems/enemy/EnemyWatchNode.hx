package arena.systems.enemy;
import arena.components.char.AggroMem;
import arena.components.enemy.EnemyWatch;
import arena.components.weapon.Weapon;
import arena.components.weapon.WeaponState;
import arena.systems.enemy.EnemyWatchNode;
import arena.systems.player.IStance;
import ash.core.Node;
import components.Pos;
import components.Rot;

/**
 * ...
 * @author Glenn Ko
 */

// For enemies that are alerted against nearest visible opposing player, and will actively look around for any other potential player targets to aggro.

class EnemyWatchNode extends Node<EnemyWatchNode> { 
	public var pos:Pos;
	public var rot:Rot;
	public var weapon:Weapon;
	public var weaponState:WeaponState;
	
	public var state:EnemyWatch;	
	public var stance:IStance;
	public var aggroMem:AggroMem;
	//public var stateMachine:EntityStateMachine;
}