class INV_DEST implements Exception{
    final String message;
    INV_DEST(this.message);

    @override
    String toString() => "INV_DEST: $message";
}

class INV_BUDG implements Exception{
    final String message;
    INV_BUDG(this.message);

    @override
    String toString() => "INV_BUDG: $message";
}

class INV_NBPPL implements Exception{
    final String message;
    INV_NBPPL(this.message);

    @override
    String toString() => "INV_NBPPL: $message";
}

class INV_DUR implements Exception{
    final String message;
    INV_DUR(this.message);

    @override
    String toString() => "INV_DUR: $message";
}
