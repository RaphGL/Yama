#import "Basic";
#import "File";

Piece :: struct {
	start, len, source: int;
}

Piece_Table :: struct {
	buffers: *[..]string;
	pieces: *[..]Piece;	
}

make_piece_table :: () -> Piece_Table {
	pt: Piece_Table;
	pt.buffers = New(type_of(pt.buffers.*));
	pt.pieces = New(type_of(pt.pieces.*));

	array_add(pt.buffers, "");

	array_add(pt.pieces, Piece.{
		start = 0,
		len = 0,
		source = 0,
	});

	return pt;
}

piece_table_from_filename :: (filename:string) -> (pt: Piece_Table, success: bool) {
	pt: Piece_Table;

	fstr, ok := read_entire_file(filename);
	if !ok {
		return pt, false;
	}

	pt.buffers = New(type_of(pt.buffers.*));
	pt.pieces = New(type_of(pt.pieces.*));

	array_add(pt.buffers, fstr);

	array_add(pt.pieces, Piece.{
		start = 0, 
		len = fstr.count, 
		source = 0, 
	});

	return pt, true;
}

delete_piece_table :: (pt: Piece_Table) {
	for buffer : pt.buffers.* {
		free(buffer);
	}

	free(pt.buffers);
	free(pt.pieces);
}

main :: () {
	pt, ok := piece_table_from_filename("test.txt");
	if !ok {
		print("failed to load piece table");
		return;
	}
	defer delete_piece_table(pt);
}



