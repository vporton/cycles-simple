import Cycles "mo:base/ExperimentalCycles";

module {
  type CanisterCyclesInfo = {
    available: Nat;
    threshold: Nat;
    installAmount: Nat;
  };

  // public func getCyclesInfo() : async Text {
  //   {
  //     available = Cycles.available();
  //   }
  // };
};
