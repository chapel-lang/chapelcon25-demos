iter atIdxs(A: [], AIdxs: [] A.domain.idxType): A.eltType {

}
for i in atIdxs([1, 2, 3], [0, 1, 2]) {
    writeln(i);
}

iter atIdxs(A: [], AIdxs: [] A.domain.idxType, param tag) : A.eltType where tag == iterKind.standalone {

}
forall i in atIdxs([1, 2, 3], [0, 1, 2]) {
    writeln(i);
}
