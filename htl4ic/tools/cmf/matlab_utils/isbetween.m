function result = isbetween(value, lower, upper, type)

if strcmpi(type, 'closed')
  result = (value >= lower & value <= upper);
elseif strcmpi(type, 'open')
  result = (value > lower & value < upper);
elseif strcmpi(type, 'leftclosed')
  result = (value >= lower & value < upper);
elseif strcmpi(type, 'rightclosed')
  result = (value > lower & value <= upper);
else
  error('MatlabUtils:InvalidArgument',...
        'type must be one of {closed, open, leftclosed, rightclosed} (%s)',...
        type);
end
