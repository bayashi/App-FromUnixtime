use strict;
use warnings;
use Test::More;
use Test::Output;

use App::FromUnixtime;

{
    open my $IN, '<', \<<'_INPUT_';
id          1
name        John
date        1419702037
_INPUT_
    local *STDIN = *$IN;
    stdout_like(
        sub { App::FromUnixtime->run; },
        qr/date\s+1419702037\([^\)]+\)/
    );
    close $IN;
}

{
    open my $IN, '<', \<<'_INPUT_';
id          1
name        John
date        1419702037
created_on  1419692400
updated_on  1419692400
created_at  1419702037
updated_at  1419702037
_INPUT_
    local *STDIN = *$IN;
    stdout_is(
        sub { App::FromUnixtime->run('--format' => '%Y-%m-%d %H:%M:%S'); },
        <<'_EXPECTED_',
id          1
name        John
date        1419702037(2014-12-28 02:40:37)
created_on  1419692400(2014-12-28 00:00:00)
updated_on  1419692400(2014-12-28 00:00:00)
created_at  1419702037(2014-12-28 02:40:37)
updated_at  1419702037(2014-12-28 02:40:37)
_EXPECTED_
    );
    close $IN;
}

done_testing;
