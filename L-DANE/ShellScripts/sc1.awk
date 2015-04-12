#!/bin/awk -f
BEGIN {
	FS=" ";
}
{
    if($1!=".")
    {
	print $0;
    }
}
