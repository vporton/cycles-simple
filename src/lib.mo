import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";

module {
  public type CanisterFulfillmentInfo = {
    threshold: Nat;
    installAmount: Nat;
  };

  public type Child = actor {
    cycles_simple_availableCycles: query () -> async Nat;
    cycles_simple_topUpCycles: (cycles: Nat) -> /*async*/ ();
  };

  public type CanisterKind = Text;

  public type CanisterMap = HashMap.HashMap<Principal, CanisterKind>;

  public type CanisterKindsMap = HashMap.HashMap<CanisterKind, CanisterFulfillmentInfo>;

  public type Battery = {
    canisterMap: CanisterMap;
    canisterKindsMap: CanisterKindsMap;
  };

  public func topUpOneCanister(battery: Battery, canisterId: Principal): async* () {
    let info0 = do ? { battery.canisterKindsMap.get(battery.canisterMap.get(canisterId)!)! };
    let ?info = info0 else {
      Debug.trap("no such canister record");
    };
    let child: Child = actor(Principal.toText(canisterId));
    let remaining = await child.cycles_simple_availableCycles();
    if (remaining <= info.threshold) {
      child.cycles_simple_topUpCycles(info.installAmount);
    };
  };

  public func topUpAllCanisters(battery: Battery): async* () {
    for (canisterId in battery.canisterMap.keys()) {
      await* topUpOneCanister(battery, canisterId);
    };
  };

  public func addCanister(battery: Battery, canisterId: Principal, kind: Text) {
    battery.canisterMap.put(canisterId, kind);
  };

  public func insertCanisterKind(battery: Battery, kind: Text, info: CanisterFulfillmentInfo) {
    battery.canisterKindsMap.put(kind, info);
  };
};
