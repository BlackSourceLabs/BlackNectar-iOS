find AromaThrift -regex '.*.h' -print0 | xargs -0 sed -i  '' 's_.*import.*"TProtocol.h"_@import LibThrift;_'
find AromaThrift -regex '.*.h' -print0 | xargs -0 sed -i  '' 's_.*import.*T.*.h"__'
find AromaThrift -regex '.*.m' -print0 | xargs -0 sed -i  '' 's_.*import.*"TProtocol.h"_@import LibThrift;_'
find AromaThrift -regex '.*.m' -print0 | xargs -0 sed -i  '' 's_.*import.*T.*.h"__'
